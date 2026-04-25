import AppKit
import Foundation

struct BrowserData: Codable {
    let tabs: [TabData]
    let bookmarks: [Bookmark]
    let history: [HistoryEntry]
    let preferences: Preferences?
}

struct TabData: Codable {
    let id: UUID
    let urlString: String
    let title: String
    let isPinned: Bool
    let scrollPosition: Double
    let zoomLevel: Double
    let isPrivate: Bool

    init(
        id: UUID,
        urlString: String,
        title: String,
        isPinned: Bool = false,
        scrollPosition: Double = 0,
        zoomLevel: Double = 1.0,
        isPrivate: Bool = false
    ) {
        self.id = id
        self.urlString = urlString
        self.title = title
        self.isPinned = isPinned
        self.scrollPosition = scrollPosition
        self.zoomLevel = zoomLevel
        self.isPrivate = isPrivate
    }
}

struct CrashRecoveryData: Codable {
    let tabs: [TabData]
    let selectedTabID: UUID?
    let timestamp: Date
}

struct Storage {
    private static let fileManager = FileManager.default
    private static let directoryURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Browser", isDirectory: true)
    private static let fileURL = directoryURL.appendingPathComponent("browser_data.json")
    private static let preferencesURL = directoryURL.appendingPathComponent("preferences.json")
    private static let crashRecoveryURL = directoryURL.appendingPathComponent("crash_recovery.json")
    private static let cleanShutdownURL = directoryURL.appendingPathComponent(".clean_shutdown")

    static func save(
        tabs: [TabData],
        bookmarks: [Bookmark],
        history: [HistoryEntry],
        preferences: Preferences? = nil
    ) {
        let cappedHistory = Array(history.prefix(500))
        let browserData = BrowserData(
            tabs: tabs,
            bookmarks: bookmarks,
            history: cappedHistory,
            preferences: preferences
        )

        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            let data = try encoder.encode(browserData)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            return
        }
    }

    static func load() -> BrowserData? {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(BrowserData.self, from: data)
        } catch {
            return nil
        }
    }

    // MARK: - Preferences

    static func savePreferences(_ preferences: Preferences) {
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            let data = try encoder.encode(preferences)
            try data.write(to: preferencesURL, options: .atomic)
        } catch {
            return
        }
    }

    static func loadPreferences() -> Preferences? {
        do {
            let data = try Data(contentsOf: preferencesURL)
            return try JSONDecoder().decode(Preferences.self, from: data)
        } catch {
            return nil
        }
    }

    // MARK: - Crash Recovery

    static func saveCrashRecoveryState(tabs: [TabData], selectedTabID: UUID?) {
        let recovery = CrashRecoveryData(
            tabs: tabs,
            selectedTabID: selectedTabID,
            timestamp: Date()
        )

        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            let data = try JSONEncoder().encode(recovery)
            try data.write(to: crashRecoveryURL, options: .atomic)
        } catch {
            return
        }
    }

    static func loadCrashRecoveryState() -> CrashRecoveryData? {
        do {
            let data = try Data(contentsOf: crashRecoveryURL)
            return try JSONDecoder().decode(CrashRecoveryData.self, from: data)
        } catch {
            return nil
        }
    }

    static func clearCrashRecoveryState() {
        try? fileManager.removeItem(at: crashRecoveryURL)
    }

    static func markCleanShutdown() {
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try? Data().write(to: cleanShutdownURL)
    }

    static func wasCleanShutdown() -> Bool {
        fileManager.fileExists(atPath: cleanShutdownURL.path)
    }

    static func clearCleanShutdownFlag() {
        try? fileManager.removeItem(at: cleanShutdownURL)
    }

    // MARK: - Bookmark Import/Export

    static func exportBookmarksHTML(_ bookmarks: [Bookmark]) -> String {
        var html = """
        <!DOCTYPE NETSCAPE-Bookmark-file-1>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
        <TITLE>Bookmarks</TITLE>
        <H1>Bookmarks</H1>
        <DL><p>
        """

        let grouped = Dictionary(grouping: bookmarks, by: { $0.folder })
        for (folder, items) in grouped.sorted(by: { $0.key < $1.key }) {
            html += "    <DT><H3>\(escapeHTML(folder))</H3>\n    <DL><p>\n"
            for bookmark in items {
                let timestamp = Int(bookmark.dateAdded.timeIntervalSince1970)
                html += "        <DT><A HREF=\"\(bookmark.url.absoluteString)\" ADD_DATE=\"\(timestamp)\">\(escapeHTML(bookmark.title))</A>\n"
            }
            html += "    </DL><p>\n"
        }

        html += "</DL><p>\n"
        return html
    }

    static func importBookmarksHTML(_ htmlString: String) -> [Bookmark] {
        var bookmarks: [Bookmark] = []
        let lines = htmlString.components(separatedBy: .newlines)
        var currentFolder = "Imported"

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("<DT><H3>") {
                if let start = trimmed.range(of: "<H3>")?.upperBound,
                   let end = trimmed.range(of: "</H3>")?.lowerBound {
                    currentFolder = String(trimmed[start..<end])
                }
            }

            if trimmed.contains("HREF=\"") {
                if let hrefStart = trimmed.range(of: "HREF=\"")?.upperBound,
                   let hrefEnd = trimmed[hrefStart...].range(of: "\"")?.lowerBound,
                   let url = URL(string: String(trimmed[hrefStart..<hrefEnd])) {

                    var title = url.host ?? url.absoluteString
                    if let titleStart = trimmed.range(of: ">", range: trimmed.range(of: "</A>")!.lowerBound..<trimmed.endIndex)?.upperBound {
                        // fallback: extract between last > and </A>
                    }
                    // Extract title between >...</A>
                    if let aStart = trimmed.range(of: "\">")?.upperBound ?? trimmed.range(of: "'>")?.upperBound,
                       let aEnd = trimmed.range(of: "</A>", options: .caseInsensitive)?.lowerBound {
                        title = String(trimmed[aStart..<aEnd])
                    }

                    bookmarks.append(Bookmark(url: url, title: title, folder: currentFolder))
                }
            }
        }

        return bookmarks
    }

    private static func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}
