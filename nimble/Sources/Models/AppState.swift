import SwiftUI
import ServiceManagement

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
        self == .contrast ? .black : .white
    }

    var textColor: Color {
        self == .contrast ? .white : .primary
    }

    var inputTextColor: Color {
        .white
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

    static func == (lhs: QueryResult, rhs: QueryResult) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.loading, .loading): return true
        case let (.math(a), .math(b)): return a == b
        case let (.error(a, _), .error(b, _)): return a == b
        default: return false
        }
    }
}

@MainActor
@Observable
final class AppState {
    var theme: NimbleTheme = .orange
    var mathEnabled: Bool = true
    var launchOnStartup: Bool = false
    var centerWindow: Bool = false
    var defaultSuggestions: Bool = true

    var queryText: String = ""
    var result: QueryResult = .none
    var currentPlaceholder: String = ""
    var searchURL: String = ""

    private let queryEngine = QueryEngine()
    private let prefs = Preferences()
    private var placeholderTimer: Timer?

    init() {
        loadPreferences()
        rotatePlaceholder()
        startPlaceholderTimer()
    }

    func loadPreferences() {
        let p = prefs.load()
        theme = NimbleTheme(rawValue: p.theme) ?? .orange
        mathEnabled = p.mathEnabled
        launchOnStartup = p.launchOnStartup
        centerWindow = p.centerWindow
        defaultSuggestions = p.defaultSuggestions
    }

    func savePreferences() {
        let p = PreferencesData(
            theme: theme.rawValue,
            mathEnabled: mathEnabled,
            launchOnStartup: launchOnStartup,
            centerWindow: centerWindow,
            defaultSuggestions: defaultSuggestions
        )
        prefs.save(p)
        applyLaunchOnStartup()
    }

    func applyLaunchOnStartup() {
        if #available(macOS 13.0, *) {
            do {
                if launchOnStartup {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                // Silently fail -- sandboxed app may not have permission
            }
        }
    }

    func performQuery() {
        let text = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
        searchURL = "https://duckduckgo.com/?q=\(encoded)"

        // Try math first
        if mathEnabled {
            if let mathResult = queryEngine.evaluateMath(text) {
                result = .math(mathResult)
                return
            }
        }

        // Query DDG + Wikipedia
        result = .loading
        let engine = queryEngine
        Task { @MainActor [weak self] in
            let queryResult = await engine.query(text)
            self?.result = queryResult
        }
    }

    func rotatePlaceholder() {
        currentPlaceholder = queryEngine.randomSuggestion(useDefaults: defaultSuggestions)
    }

    func onPopoverOpen() {
        // Called when popover appears -- focus the input
    }

    func copyResultText() {
        let text: String
        switch result {
        case .math(let s): text = s
        case .text(_, let body, _, _, _): text = body
        case .list(let items, _): text = items.joined(separator: "\n")
        case .error(let msg, _): text = msg
        default: return
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    func copySearchLink() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(searchURL, forType: .string)
    }

    func openInDDG() {
        guard let url = URL(string: searchURL) else { return }
        NSWorkspace.shared.open(url)
    }

    private func startPlaceholderTimer() {
        placeholderTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.rotatePlaceholder()
            }
        }
    }
}
