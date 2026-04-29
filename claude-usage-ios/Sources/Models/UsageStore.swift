import SwiftUI

@MainActor
@Observable
final class UsageStore {
    var entries: [UsageEntry] = []
    var settings: UsageSettings = UsageSettings()
    var showingAddEntry: Bool = false
    var editingEntry: UsageEntry? = nil
    var selectedProvider: AIProvider? = nil

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

    // MARK: - Computed

    var filteredEntries: [UsageEntry] {
        guard let p = selectedProvider else { return entries }
        return entries.filter { $0.provider == p }
    }

    var currentMonthEntries: [UsageEntry] {
        let cal = Calendar.current
        return filteredEntries.filter { cal.isDate($0.date, equalTo: Date(), toGranularity: .month) }
    }

    var currentMonthConversations: Int { currentMonthEntries.reduce(0) { $0 + $1.conversations } }
    var currentMonthTokens: Int { currentMonthEntries.reduce(0) { $0 + $1.tokensEstimate } }
    var currentMonthCost: Double { currentMonthEntries.reduce(0) { $0 + $1.costEstimate } }

    var totalMonthlyBudget: Double {
        settings.claudeMonthly + settings.chatgptMonthly + settings.geminiMonthly
    }

    func budget(for provider: AIProvider) -> Double {
        switch provider {
        case .claude: settings.claudeMonthly
        case .chatgpt: settings.chatgptMonthly
        case .gemini: settings.geminiMonthly
        case .custom: 0
        }
    }

    func monthlyBreakdown() -> [(provider: AIProvider, conversations: Int, cost: Double)] {
        AIProvider.allCases.compactMap { provider in
            let items = currentMonthEntries.filter { $0.provider == provider }
            guard !items.isEmpty else { return nil }
            return (provider, items.reduce(0) { $0 + $1.conversations }, items.reduce(0) { $0 + $1.costEstimate })
        }
    }

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

    func exportJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let payload = ExportPayload(entries: entries, settings: settings, exportedAt: Date())
        return (try? String(data: encoder.encode(payload), encoding: .utf8)) ?? "{}"
    }

    func importJSON(_ string: String) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let data = string.data(using: .utf8) else { throw ImportError.invalidData }
        let payload = try decoder.decode(ExportPayload.self, from: data)
        entries = payload.entries.sorted { $0.date > $1.date }
        settings = payload.settings
        save()
    }

    enum ImportError: LocalizedError {
        case invalidData
        var errorDescription: String? { "Invalid JSON data" }
    }

    // Shared data for widget
    var widgetSummary: WidgetSummary {
        WidgetSummary(
            monthConversations: currentMonthConversations,
            monthCost: currentMonthCost,
            currency: settings.currency
        )
    }
}

struct WidgetSummary: Codable {
    var monthConversations: Int
    var monthCost: Double
    var currency: String
}

private struct ExportPayload: Codable {
    var entries: [UsageEntry]
    var settings: UsageSettings
    var exportedAt: Date
}
