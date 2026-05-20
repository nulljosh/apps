import SwiftUI
import Observation
import Supabase

// MARK: - DB row types

struct BriefJournalRow: Decodable {
    let date: String
    let text: String
}

struct BriefChecklistRow: Decodable {
    let item_index: Int
    let completed: Bool
}

struct BriefLawyerRow: Decodable {
    let lawyer_id: String
    let status: String
}

// MARK: - Upsert payloads (typed so Swift can infer Encodable)

private struct JournalUpsert: Encodable {
    let user_id: String; let date: String; let text: String
}
private struct ChecklistUpsert: Encodable {
    let user_id: String; let item_index: Int; let completed: Bool
}
private struct LawyerUpsert: Encodable {
    let user_id: String; let lawyer_id: String; let status: String
}

// MARK: - Store

private let ALLOWED_EMAIL = "jatrommel@gmail.com"

enum AuthStep { case email, password }

@MainActor
@Observable
final class Store {
    var needsSignIn = true
    var authStep: AuthStep = .email
    var signInError: String?
    var activeCase: CaseID = .rcmp
    private(set) var journalEntries: [JournalEntry] = []
    private(set) var completedItems: Set<Int> = [1, 8, 9, 10, 13]
    private(set) var lawyerStatuses: [String: String] = [:]
    private var userId: String?

    let statusCycle = ["none", "voicemail", "emailed", "callback", "retained"]
    let statusLabel: [String: String] = [
        "none": "Not contacted", "voicemail": "Voicemail left",
        "emailed": "Email sent", "callback": "Callback received", "retained": "Retained"
    ]

    init() {}

    @MainActor func checkSession() async {
        do {
            let session = try await sbClient.auth.session
            userId = session.user.id.uuidString
            needsSignIn = false
            await loadAll()
        } catch {
            needsSignIn = true
        }
    }

    @MainActor func confirmEmail(email: String) {
        guard email == ALLOWED_EMAIL else { signInError = "Access restricted."; return }
        signInError = nil
        authStep = .password
    }

    @MainActor func resetAuthStep() {
        authStep = .email
        signInError = nil
    }

    @MainActor func signIn(email: String, password: String) async {
        signInError = nil
        do {
            try await sbClient.auth.signIn(email: email, password: password)
            let session = try await sbClient.auth.session
            userId = session.user.id.uuidString
            needsSignIn = false
            Task { await loadAll() }
        } catch {
            signInError = error.localizedDescription
        }
    }

    @MainActor func loadAll() async {
        await loadJournal()
        await loadChecklist()
        await loadLawyerStatuses()
    }

    @MainActor private func loadJournal() async {
        let rows: [BriefJournalRow]? = try? await sbClient
            .from("brief_journal").select().order("date", ascending: false)
            .execute().value
        var map: [String: JournalEntry] = [:]
        journalSeed.forEach { map[$0.date] = $0 }
        (rows ?? []).forEach { map[$0.date] = JournalEntry(date: $0.date, text: $0.text) }
        journalEntries = map.values.sorted { $0.date > $1.date }
    }

    @MainActor func addJournalEntry(date: String, text: String) async {
        guard let uid = userId else { return }
        _ = try? await sbClient.from("brief_journal")
            .upsert(JournalUpsert(user_id: uid, date: date, text: text))
            .execute()
        await loadJournal()
    }

    @MainActor func deleteJournalEntry(date: String) async {
        guard let uid = userId else { return }
        _ = try? await sbClient.from("brief_journal")
            .delete().eq("user_id", value: uid).eq("date", value: date)
            .execute()
        await loadJournal()
    }

    @MainActor private func loadChecklist() async {
        let rows: [BriefChecklistRow]? = try? await sbClient
            .from("brief_checklist").select().execute().value
        var done: Set<Int> = [1, 8, 9, 10, 13]
        (rows ?? []).forEach { if $0.completed { done.insert($0.item_index) } else { done.remove($0.item_index) } }
        completedItems = done
    }

    @MainActor func toggleItem(_ index: Int) async {
        guard let uid = userId else { return }
        let nowDone = !completedItems.contains(index)
        if nowDone { completedItems.insert(index) } else { completedItems.remove(index) }
        _ = try? await sbClient.from("brief_checklist")
            .upsert(ChecklistUpsert(user_id: uid, item_index: index, completed: nowDone))
            .execute()
    }

    @MainActor private func loadLawyerStatuses() async {
        let rows: [BriefLawyerRow]? = try? await sbClient
            .from("brief_lawyer_status").select().execute().value
        var map: [String: String] = [:]
        (rows ?? []).forEach { map[$0.lawyer_id] = $0.status }
        lawyerStatuses = map
    }

    @MainActor func cycleLawyerStatus(_ lawyerId: String) async {
        guard let uid = userId else { return }
        let cur = lawyerStatuses[lawyerId] ?? "none"
        let idx = statusCycle.firstIndex(of: cur) ?? 0
        let next = statusCycle[(idx + 1) % statusCycle.count]
        lawyerStatuses[lawyerId] = next
        _ = try? await sbClient.from("brief_lawyer_status")
            .upsert(LawyerUpsert(user_id: uid, lawyer_id: lawyerId, status: next))
            .execute()
    }
}
