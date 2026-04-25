import Foundation

struct PreferencesData: Codable {
    var theme: String = "orange"
    var mathEnabled: Bool = true
    var launchOnStartup: Bool = false
    var centerWindow: Bool = false
    var defaultSuggestions: Bool = true
}

final class Preferences {
    private let path: String

    init() {
        path = NSHomeDirectory() + "/.nimble-options.json"
    }

    func load() -> PreferencesData {
        guard let data = FileManager.default.contents(atPath: path) else {
            return PreferencesData()
        }
        do {
            return try JSONDecoder().decode(PreferencesData.self, from: data)
        } catch {
            return PreferencesData()
        }
    }

    func save(_ prefs: PreferencesData) {
        do {
            let data = try JSONEncoder().encode(prefs)
            let json = try JSONSerialization.jsonObject(with: data)
            let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            try pretty.write(to: URL(fileURLWithPath: path))
        } catch {
            // Silent fail
        }
    }
}
