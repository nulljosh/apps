import SwiftUI
import Observation
import Supabase

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

@Observable
final class Store {
    var theme: String {
        didSet { UserDefaults.standard.set(theme, forKey: "brief.theme") }
    }
    var needsSignIn = true
    var magicLinkSent = false
    var signInError: String?
    private(set) var journalEntries: [JournalEntry] = []
    private(set) var completedItems: Set<Int> = [1, 8, 9, 10, 13]
    private(set) var lawyerStatuses: [String: String] = [:]

    let statusCycle = ["none", "voicemail", "emailed", "callback", "retained"]
    let statusLabel = ["none": "Not contacted", "voicemail": "Voicemail left", "emailed": "Email sent", "callback": "Callback received", "retained": "Retained"]

    init() {
        theme = UserDefaults.standard.string(forKey: "brief.theme") ?? "dark"
        Task { await checkSession() }
    }

    @MainActor
    func checkSession() async {
        if let session = try? await sbClient.auth.session {
            needsSignIn = false
            await loadAll()
            _ = session
        }
    }

    @MainActor
    func signIn(email: String) async {
        signInError = nil
        do {
            try await sbClient.auth.signInWithOTP(email: email, redirectTo: URL(string: "brief://login-callback"))
            magicLinkSent = true
        } catch {
            signInError = error.localizedDescription
        }
    }

    @MainActor
    func handleURL(_ url: URL) async {
        do {
            try await sbClient.auth.session(from: url)
            needsSignIn = false
            await loadAll()
        } catch {}
    }

    @MainActor
    func loadAll() async {
        await loadJournal()
        await loadChecklist()
        await loadLawyerStatuses()
    }

    @MainActor
    private func loadJournal() async {
        guard let rows = try? await sbClient.from("brief_journal").select().order("date", ascending: false).execute().value as [BriefJournalRow] else { return }
        var map: [String: JournalEntry] = [:]
        journalSeed.forEach { map[$0.date] = $0 }
        rows.forEach { map[$0.date] = JournalEntry(date: $0.date, text: $0.text) }
        journalEntries = map.values.sorted { $0.date > $1.date }
    }

    @MainActor
    func addJournalEntry(date: String, text: String) async {
        guard let uid = try? await sbClient.auth.session.user.id else { return }
        try? await sbClient.from("brief_journal").upsert(["user_id": uid.uuidString, "date": date, "text": text]).execute()
        await loadJournal()
    }

    @MainActor
    private func loadChecklist() async {
        guard let rows = try? await sbClient.from("brief_checklist").select().execute().value as [BriefChecklistRow] else { return }
        var done: Set<Int> = [1, 8, 9, 10, 13]
        rows.forEach { if $0.completed { done.insert($0.item_index) } else { done.remove($0.item_index) } }
        completedItems = done
    }

    @MainActor
    func toggleItem(_ index: Int) async {
        guard let uid = try? await sbClient.auth.session.user.id else { return }
        let nowDone = !completedItems.contains(index)
        if nowDone { completedItems.insert(index) } else { completedItems.remove(index) }
        try? await sbClient.from("brief_checklist").upsert(["user_id": uid.uuidString, "item_index": index, "completed": nowDone]).execute()
    }

    @MainActor
    private func loadLawyerStatuses() async {
        guard let rows = try? await sbClient.from("brief_lawyer_status").select().execute().value as [BriefLawyerRow] else { return }
        var map: [String: String] = [:]
        rows.forEach { map[$0.lawyer_id] = $0.status }
        lawyerStatuses = map
    }

    @MainActor
    func cycleLawyerStatus(_ lawyerId: String) async {
        guard let uid = try? await sbClient.auth.session.user.id else { return }
        let cur = lawyerStatuses[lawyerId] ?? "none"
        let idx = statusCycle.firstIndex(of: cur) ?? 0
        let next = statusCycle[(idx + 1) % statusCycle.count]
        lawyerStatuses[lawyerId] = next
        try? await sbClient.from("brief_lawyer_status").upsert(["user_id": uid.uuidString, "lawyer_id": lawyerId, "status": next]).execute()
    }
}
