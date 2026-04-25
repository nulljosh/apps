import SwiftUI

@MainActor
@Observable
final class UsageStore {
    var entries: [UsageEntry] = []
    var settings: UsageSettings = UsageSettings()

    // UI state
    var showingAddEntry: Bool = false
    var editingEntry: UsageEntry? = nil
    var selectedTab: Tab = .dashboard
    var selectedProvider: AIProvider? = nil

    enum Tab: String, CaseIterable {
        case dashboard = "Dashboard"
        case entries = "Entries"
        case charts = "Charts"
    }

    private let entriesKey = "claude_usage_entries_v1"
    private let settingsKey = "claude_usage_settings_v1"

    init() {
        load()
    }

    // MARK: - Persistence

    func load() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([UsageEntry].self, from: data) {
            entries = decoded.sorted { $0.date > $1.date }
        }
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(UsageSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }

    // MARK: - CRUD

    func add(_ entry: UsageEntry) {
        entries.insert(entry, at: 0)
        entries.sort { $0.date > $1.date }
        save()
    }

    func update(_ entry: UsageEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
            entries.sort { $0.date > $1.date }
            save()
        }
    }

    func delete(_ entry: UsageEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func deleteEntries(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Stats

    var filteredEntries: [UsageEntry] {
        if let provider = selectedProvider {
            return entries.filter { $0.provider == provider }
        }
        return entries
    }

    var totalConversations: Int {
        filteredEntries.reduce(0) { $0 + $1.conversations }
    }

    var totalTokens: Int {
        filteredEntries.reduce(0) { $0 + $1.tokensEstimate }
    }

    var totalCost: Double {
        filteredEntries.reduce(0) { $0 + $1.costEstimate }
    }

    func monthlyEntries(for date: Date) -> [UsageEntry] {
        let cal = Calendar.current
        return filteredEntries.filter {
            cal.isDate($0.date, equalTo: date, toGranularity: .month)
        }
    }

    var currentMonthEntries: [UsageEntry] {
        monthlyEntries(for: Date())
    }

    var currentMonthConversations: Int {
        currentMonthEntries.reduce(0) { $0 + $1.conversations }
    }

    var currentMonthTokens: Int {
        currentMonthEntries.reduce(0) { $0 + $1.tokensEstimate }
    }

    var currentMonthCost: Double {
        currentMonthEntries.reduce(0) { $0 + $1.costEstimate }
    }

    // Per-provider breakdown for current month
    func monthlyBreakdown() -> [(provider: AIProvider, conversations: Int, tokens: Int, cost: Double)] {
        AIProvider.allCases.compactMap { provider in
            let items = currentMonthEntries.filter { $0.provider == provider }
            guard !items.isEmpty else { return nil }
            return (
                provider: provider,
                conversations: items.reduce(0) { $0 + $1.conversations },
                tokens: items.reduce(0) { $0 + $1.tokensEstimate },
                cost: items.reduce(0) { $0 + $1.costEstimate }
            )
        }
    }

    // Last 30 days grouped by date
    func last30DaysActivity() -> [(date: Date, conversations: Int)] {
        let cal = Calendar.current
        let today = Date()
        return (0..<30).compactMap { offset -> (Date, Int)? in
            guard let day = cal.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let count = filteredEntries
                .filter { cal.isDate($0.date, inSameDayAs: day) }
                .reduce(0) { $0 + $1.conversations }
            return (day, count)
        }.reversed()
    }

    // MARK: - Export/Import

    func exportJSON() -> String {
        let payload = ExportPayload(entries: entries, settings: settings, exportedAt: Date())
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return (try? String(data: encoder.encode(payload), encoding: .utf8)) ?? "{}"
    }

    func importJSON(_ string: String) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let data = string.data(using: .utf8) else {
            throw ImportError.invalidData
        }
        let payload = try decoder.decode(ExportPayload.self, from: data)
        entries = payload.entries.sorted { $0.date > $1.date }
        settings = payload.settings
        save()
    }

    enum ImportError: LocalizedError {
        case invalidData
        var errorDescription: String? { "Invalid JSON data" }
    }
}

private struct ExportPayload: Codable {
    var entries: [UsageEntry]
    var settings: UsageSettings
    var exportedAt: Date
}
