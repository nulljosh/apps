import Foundation

enum SearchEngine: String, Codable, CaseIterable, Identifiable {
    case duckDuckGo = "DuckDuckGo"
    case google = "Google"
    case bing = "Bing"
    case ecosia = "Ecosia"

    var id: String { rawValue }

    var searchBaseURL: String {
        switch self {
        case .duckDuckGo: return "https://duckduckgo.com/?q="
        case .google: return "https://www.google.com/search?q="
        case .bing: return "https://www.bing.com/search?q="
        case .ecosia: return "https://www.ecosia.org/search?q="
        }
    }

    var homeURL: URL {
        switch self {
        case .duckDuckGo: return URL(string: "https://duckduckgo.com")!
        case .google: return URL(string: "https://www.google.com")!
        case .bing: return URL(string: "https://www.bing.com")!
        case .ecosia: return URL(string: "https://www.ecosia.org")!
        }
    }
}

struct SiteZoom: Codable, Identifiable {
    var id: String { host }
    let host: String
    var zoomLevel: Double
}

struct Preferences: Codable {
    var searchEngine: SearchEngine = .duckDuckGo
    var homepage: String = "https://heyitsmejosh.com"
    var downloadsDirectory: String = ""
    var contentBlockerEnabled: Bool = true
    var httpsOnlyMode: Bool = false
    var autoClearOnQuit: Bool = false
    var customUserAgent: String = ""
    var defaultZoom: Double = 1.0
    var siteZoomLevels: [SiteZoom] = []
    var showBookmarkBar: Bool = true
    var verticalTabs: Bool = false
    var startPageEnabled: Bool = true
    var enableExtensions: Bool = false
    var enableSync: Bool = false
    var tabSuspensionMinutes: Int = 5

    var homepageURL: URL {
        URL(string: homepage) ?? SearchEngine.duckDuckGo.homeURL
    }

    func zoomLevel(for host: String) -> Double {
        siteZoomLevels.first { $0.host == host }?.zoomLevel ?? defaultZoom
    }

    mutating func setZoomLevel(_ level: Double, for host: String) {
        if let index = siteZoomLevels.firstIndex(where: { $0.host == host }) {
            if abs(level - defaultZoom) < 0.01 {
                siteZoomLevels.remove(at: index)
            } else {
                siteZoomLevels[index].zoomLevel = level
            }
        } else if abs(level - defaultZoom) >= 0.01 {
            siteZoomLevels.append(SiteZoom(host: host, zoomLevel: level))
        }
    }

    var resolvedDownloadsDirectory: URL {
        if !downloadsDirectory.isEmpty, FileManager.default.fileExists(atPath: downloadsDirectory) {
            return URL(fileURLWithPath: downloadsDirectory)
        }
        return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads")
    }
}
