import SwiftUI
import Observation

@Observable
final class Store {
    var theme: String {
        didSet { UserDefaults.standard.set(theme, forKey: "brief.theme") }
    }
    var completedItems: Set<Int> {
        didSet {
            let arr = Array(completedItems)
            UserDefaults.standard.set(try? JSONEncoder().encode(arr), forKey: "brief.checklist")
        }
    }
    private(set) var journalEntries: [JournalEntry] = []

    init() {
        theme = UserDefaults.standard.string(forKey: "brief.theme") ?? "dark"

        if let data = UserDefaults.standard.data(forKey: "brief.checklist"),
           let arr = try? JSONDecoder().decode([Int].self, from: data) {
            completedItems = Set(arr)
        } else {
            completedItems = [1, 8, 9, 10, 13]
        }

        loadJournal()
    }

    private func loadJournal() {
        var map: [String: JournalEntry] = [:]
        journalSeed.forEach { map[$0.date] = $0 }

        if let data = UserDefaults.standard.data(forKey: "brief.journal"),
           let saved = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            saved.forEach { map[$0.date] = $0 }
        }

        journalEntries = map.values.sorted { $0.date > $1.date }
    }

    func addJournalEntry(date: String, text: String) {
        var saved: [JournalEntry] = []
        if let data = UserDefaults.standard.data(forKey: "brief.journal") {
            saved = (try? JSONDecoder().decode([JournalEntry].self, from: data)) ?? []
        }
        saved.removeAll { $0.date == date }
        saved.append(JournalEntry(date: date, text: text))
        UserDefaults.standard.set(try? JSONEncoder().encode(saved), forKey: "brief.journal")
        loadJournal()
    }
}
