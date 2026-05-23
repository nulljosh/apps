import Foundation

struct PreferencesData: Codable {
    var theme: String = "orange"
    var mathEnabled: Bool = true
    var defaultSuggestions: Bool = true
}

final class Preferences {
    private let defaults = UserDefaults.standard
    private let key = "nimble_preferences"

    func load() -> PreferencesData {
        guard let data = defaults.data(forKey: key) else {
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
            defaults.set(data, forKey: key)
        } catch {
            // Silent fail
        }
    }
}
