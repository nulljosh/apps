import SwiftUI
import UIKit

enum NimbleTheme: String, CaseIterable, Codable {
    case orange, red, yellow, green, blue, purple, pink, contrast

    var color: Color {
        switch self {
        case .orange: Color(red: 1.0, green: 0.55, blue: 0.07)
        case .red: Color(red: 0.86, green: 0, blue: 0)
        case .yellow: Color(red: 1.0, green: 0.79, blue: 0.19)
        case .green: Color(red: 0.46, green: 0.75, blue: 0.13)
        case .blue: Color(red: 0.16, green: 0.49, blue: 0.91)
        case .purple: Color(red: 0.38, green: 0.02, blue: 0.69)
        case .pink: Color(red: 0.82, green: 0.02, blue: 0.63)
        case .contrast: Color.white
        }
    }

    var backgroundColor: Color {
        self == .contrast ? .black : Color(.systemBackground)
    }

    var textColor: Color {
        self == .contrast ? .white : .primary
    }

    var displayName: String {
        rawValue.capitalized
    }
}

enum QueryResult: Equatable {
    case none
    case loading
    case math(String)
    case text(heading: String?, body: String, source: String, sourceURL: String?, imageURL: String?)
    case list(items: [String], source: String)
    case error(String, searchURL: String?)
    case color(String)
    case convert(from: String, to: String, fromUnit: String, toUnit: String)

    static func == (lhs: QueryResult, rhs: QueryResult) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.loading, .loading): return true
        case let (.math(a), .math(b)): return a == b
        case let (.error(a, _), .error(b, _)): return a == b
        default: return false
        }
    }
}

struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let query: String
    let preview: String
    let type: String

    static func from(_ query: String, result: QueryResult) -> HistoryEntry? {
        let preview: String
        let type: String
        switch result {
        case .math(let v):   preview = v;                       type = "math"
        case .text(let h, let b, _, _, _): preview = h ?? String(b.prefix(30)); type = "text"
        case .list(let items, _): preview = items.first ?? ""; type = "list"
        case .color(let hex): preview = "#\(hex.uppercased())"; type = "color"
        case .convert(_, let to, _, let tu): preview = "\(to) \(tu)";           type = "convert"
        default: return nil
        }
        return HistoryEntry(id: UUID(), query: query, preview: preview, type: type)
    }
}

@MainActor
@Observable
final class AppState {
    var theme: NimbleTheme = .orange
    var mathEnabled: Bool = true
    var defaultSuggestions: Bool = true

    var queryText: String = ""
    var result: QueryResult = .none
    var webResults: [WebResult] = []
    var currentPlaceholder: String = ""
    var searchURL: String = ""
    var showSettings: Bool = false
    var safariURL: URL? = nil
    var history: [HistoryEntry] = []

    private let queryEngine = QueryEngine()
    private let prefs = Preferences()
    private var placeholderTimer: Timer?
    private var searchTask: Task<Void, Never>?

    init() {
        loadPreferences()
        loadHistory()
        rotatePlaceholder()
        startPlaceholderTimer()
    }

    func loadPreferences() {
        let p = prefs.load()
        theme = NimbleTheme(rawValue: p.theme) ?? .orange
        mathEnabled = p.mathEnabled
        defaultSuggestions = p.defaultSuggestions
    }

    func savePreferences() {
        let p = PreferencesData(
            theme: theme.rawValue,
            mathEnabled: mathEnabled,
            defaultSuggestions: defaultSuggestions
        )
        prefs.save(p)
    }

    func scheduleSearch() {
        let text = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTask?.cancel()
        guard !text.isEmpty else {
            result = .none
            webResults = []
            return
        }
        searchTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled, let self else { return }
            self.performQuery()
        }
    }

    func submitQuery() {
        searchTask?.cancel()
        performQuery()
    }

    func performQuery() {
        let text = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
        searchURL = "https://duckduckgo.com/?q=\(encoded)"

        if mathEnabled {
            if let mathResult = queryEngine.evaluateMath(text) {
                result = .math(mathResult)
                triggerHaptic(.success)
                addToHistory(query: text, result: result)
                return
            }
        }

        result = .loading
        webResults = []
        let engine = queryEngine
        Task { @MainActor [weak self] in
            async let instantTask = engine.query(text)
            async let webTask = engine.fetchWebResults(text)
            let (queryResult, results) = await (instantTask, webTask)
            self?.result = queryResult
            self?.webResults = results
            switch queryResult {
            case .text, .list, .math, .color, .convert:
                self?.triggerHaptic(.success)
                if let self { self.addToHistory(query: text, result: queryResult) }
            case .error:
                self?.triggerHaptic(.error)
            default:
                break
            }
        }
    }

    func rotatePlaceholder() {
        currentPlaceholder = queryEngine.randomSuggestion(useDefaults: defaultSuggestions)
    }

    func copyResultText() {
        let text: String
        switch result {
        case .math(let s): text = s
        case .text(_, let body, _, _, _): text = body
        case .list(let items, _): text = items.joined(separator: "\n")
        case .error(let msg, _): text = msg
        case .color(let hex): text = hex
        case .convert(let from, let to, let fromUnit, let toUnit): text = "\(from) \(fromUnit) = \(to) \(toUnit)"
        default: return
        }
        UIPasteboard.general.string = text
        triggerHaptic(.success)
    }

    func openSourceURL() {
        switch result {
        case .text(_, _, _, let url, _):
            if let url, let u = URL(string: url) { safariURL = u }
        default:
            if let url = URL(string: searchURL) { safariURL = url }
        }
    }

    private func addToHistory(query: String, result: QueryResult) {
        guard let entry = HistoryEntry.from(query, result: result) else { return }
        history.removeAll { $0.query == query }
        history.insert(entry, at: 0)
        if history.count > 10 { history.removeLast() }
        saveHistory()
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: "nimble.history"),
              let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) else { return }
        history = decoded
    }

    private func saveHistory() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: "nimble.history")
    }

    private func triggerHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    private func startPlaceholderTimer() {
        placeholderTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.rotatePlaceholder()
            }
        }
    }
}
