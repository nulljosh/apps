import Foundation
import Observation
import WebKit

@MainActor
@Observable
final class AppState {
    static let shared = AppState()

    var tabs: [Tab]
    var selectedTabID: UUID?
    var bookmarks: [Bookmark]
    var history: [HistoryEntry]
    var preferences: Preferences
    var showFindBar = false
    var findText = ""
    var loadingProgress: Double = 0
    var errorMessage: String?
    var showError = false

    // Closed tabs stack (for reopen)
    var closedTabs: [TabData] = []

    // Reader mode
    var showReaderMode = false
    var readerTitle: String?
    var readerContent: String?

    // UI state
    var showBookmarkBar = true
    var isFullscreen = false
    var verticalTabs = false
    var autocompleteResults: [AutocompleteEntry] = []
    var showAutocomplete = false

    // Private browsing
    var isPrivateMode = false

    private var webViews: [UUID: WKWebView] = [:]
    private var persistentDataStore: WKWebsiteDataStore = .default()
    private var ephemeralDataStore: WKWebsiteDataStore = .nonPersistent()

    struct AutocompleteEntry: Identifiable {
        let id = UUID()
        let title: String
        let url: URL
    }

    private init() {
        let loadedPrefs = Storage.loadPreferences() ?? Preferences()
        preferences = loadedPrefs

        // Must initialize all stored properties before accessing self
        if let storedData = Storage.load() {
            let restoredTabs = storedData.tabs.compactMap(Self.makeTab(from:))

            if restoredTabs.isEmpty {
                let firstTab = Self.makeDefaultTab()
                tabs = [firstTab]
                selectedTabID = firstTab.id
            } else {
                tabs = restoredTabs
                selectedTabID = restoredTabs.first?.id
            }

            bookmarks = storedData.bookmarks
            history = Array(storedData.history.prefix(500))
        } else {
            let firstTab = Self.makeDefaultTab()
            tabs = [firstTab]
            selectedTabID = firstTab.id
            bookmarks = [
                Bookmark(url: URL.homeURL, title: "DuckDuckGo", folder: "Favorites"),
                Bookmark(
                    url: URL(string: "https://developer.apple.com/documentation/webkit")!,
                    title: "WebKit Docs",
                    folder: "Development"
                )
            ]
            history = []
        }

        // Now safe to access self
        showBookmarkBar = loadedPrefs.showBookmarkBar
        verticalTabs = loadedPrefs.verticalTabs

        // Start crash recovery timer
        TabManager.shared.startCrashRecoveryTimer { [weak self] in
            self?.saveCrashRecoveryState()
        }

        // Start tab suspension timer
        TabManager.shared.startSuspensionTimer(suspensionMinutes: preferences.tabSuspensionMinutes) { [weak self] tabID, lastAccess in
            self?.checkTabSuspension(tabID: tabID, lastAccess: lastAccess)
        }

        // Compile content blocker rules
        if preferences.contentBlockerEnabled {
            PrivacyManager.shared.compileContentBlockerRules()
        }

        // Load extensions
        if preferences.enableExtensions {
            ExtensionManager.shared.loadExtensions()
            ExtensionManager.shared.startBackgroundScripts()
        }
    }

    var selectedTab: Tab? {
        guard let selectedTabID else { return nil }
        return tabs.first { $0.id == selectedTabID }
    }

    var isCurrentPageBookmarked: Bool {
        guard let currentURL = selectedTab?.url else { return false }
        return bookmarks.contains { $0.url == currentURL }
    }

    var pinnedTabs: [Tab] {
        tabs.filter { $0.isPinned }
    }

    var unpinnedTabs: [Tab] {
        tabs.filter { !$0.isPinned }
    }

    // MARK: - Tab Management

    func tab(for id: UUID) -> Tab? {
        tabs.first { $0.id == id }
    }

    func addTab(url: URL = .homeURL, isPrivate: Bool = false) {
        let tab = Tab(
            url: url,
            title: url.host ?? "New Tab",
            isPrivate: isPrivate || isPrivateMode
        )
        tabs.append(tab)
        selectedTabID = tab.id
        TabManager.shared.markAccessed(tabID: tab.id)
        persistState()
        load(url: url, in: tab.id)
    }

    func closeTab(id: UUID) {
        guard tabs.count > 1 else { return }
        guard let index = tabs.firstIndex(where: { $0.id == id }) else { return }

        let closedTab = tabs[index]
        if !closedTab.isPrivate {
            let tabData = TabData(
                id: closedTab.id,
                urlString: closedTab.url.absoluteString,
                title: closedTab.title,
                isPinned: closedTab.isPinned,
                scrollPosition: Double(closedTab.scrollPosition),
                zoomLevel: closedTab.zoomLevel
            )
            closedTabs.append(tabData)
            if closedTabs.count > 10 {
                closedTabs.removeFirst()
            }
        }

        tabs.remove(at: index)
        webViews[id] = nil
        PrivacyManager.shared.removeTrackerCount(for: id)
        TabManager.shared.removeTab(tabID: id)

        if selectedTabID == id {
            let fallbackIndex = min(index, tabs.count - 1)
            selectedTabID = tabs[fallbackIndex].id
        }

        persistState()
    }

    func reopenClosedTab() {
        guard let lastClosed = closedTabs.popLast() else { return }
        guard let url = URL(string: lastClosed.urlString) else { return }
        addTab(url: url)
    }

    func selectTab(id: UUID) {
        selectedTabID = id
        TabManager.shared.markAccessed(tabID: id)

        // Unsuspend if needed
        if let index = tabs.firstIndex(where: { $0.id == id }), tabs[index].isSuspended {
            tabs[index].isSuspended = false
            load(url: tabs[index].url, in: id)
        }
    }

    func moveTab(from sourceIndex: Int, to destinationIndex: Int) {
        guard tabs.indices.contains(sourceIndex), destinationIndex >= 0, destinationIndex <= tabs.count else { return }
        let tab = tabs.remove(at: sourceIndex)
        let adjustedIndex = destinationIndex > sourceIndex ? destinationIndex - 1 : destinationIndex
        tabs.insert(tab, at: min(adjustedIndex, tabs.count))
        persistState()
    }

    func pinTab(id: UUID) {
        guard let index = tabs.firstIndex(where: { $0.id == id }) else { return }
        tabs[index].isPinned = true
        // Move pinned tabs to front
        let tab = tabs.remove(at: index)
        let insertIndex = tabs.lastIndex(where: { $0.isPinned }).map { $0 + 1 } ?? 0
        tabs.insert(tab, at: insertIndex)
        persistState()
    }

    func unpinTab(id: UUID) {
        guard let index = tabs.firstIndex(where: { $0.id == id }) else { return }
        tabs[index].isPinned = false
        persistState()
    }

    func togglePinTab(id: UUID) {
        guard let tab = tab(for: id) else { return }
        if tab.isPinned {
            unpinTab(id: id)
        } else {
            pinTab(id: id)
        }
    }

    func toggleMuteTab(id: UUID) {
        guard let index = tabs.firstIndex(where: { $0.id == id }) else { return }
        tabs[index].isMuted.toggle()

        if let webView = webViews[id] {
            let muted = tabs[index].isMuted
            webView.evaluateJavaScript("""
                document.querySelectorAll('video, audio').forEach(el => el.muted = \(muted));
            """)
        }
    }

    // MARK: - WebView Management

    func webView(for tabID: UUID) -> WKWebView {
        if let existing = webViews[tabID] {
            return existing
        }

        let isPrivate = tab(for: tabID)?.isPrivate ?? false
        let config = WKWebViewConfiguration()
        config.websiteDataStore = isPrivate ? ephemeralDataStore : persistentDataStore

        // Apply content blocker rules
        if preferences.contentBlockerEnabled, let ruleList = PrivacyManager.shared.compiledRuleList {
            config.userContentController.add(ruleList)
        }

        // Custom user agent
        let webView = WKWebView(frame: .zero, configuration: config)
        if !preferences.customUserAgent.isEmpty {
            webView.customUserAgent = preferences.customUserAgent
        }

        // Apply zoom level
        if let host = tab(for: tabID)?.url.host {
            let zoom = preferences.zoomLevel(for: host)
            webView.pageZoom = zoom
        }

        webViews[tabID] = webView
        return webView
    }

    func removeWebView(for tabID: UUID) {
        webViews[tabID] = nil
    }

    func hasWebView(for tabID: UUID) -> Bool {
        webViews[tabID] != nil
    }

    // MARK: - Navigation

    func load(url: URL, in tabID: UUID) {
        guard let index = tabs.firstIndex(where: { $0.id == tabID }) else { return }

        let didChangeURL = tabs[index].url != url
        if didChangeURL {
            tabs[index].url = url
        }

        if !tabs[index].isLoading {
            tabs[index].isLoading = true
        }

        if didChangeURL {
            persistState()
        }

        webView(for: tabID).load(URLRequest(url: url))
    }

    func openInSelectedTab(_ url: URL) {
        guard let selectedTabID else { return }
        load(url: url, in: selectedTabID)
    }

    func navigateCurrent(input: String) {
        guard let url = URL.fromUserInput(input, searchEngine: preferences.searchEngine) else { return }
        openInSelectedTab(url)
    }

    func goBack() {
        guard let selectedTabID, let webView = webViews[selectedTabID], webView.canGoBack else { return }
        webView.goBack()
    }

    func goForward() {
        guard let selectedTabID, let webView = webViews[selectedTabID], webView.canGoForward else { return }
        webView.goForward()
    }

    func reload() {
        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }
        webView.reload()
    }

    func stopLoading() {
        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }
        webView.stopLoading()
    }

    // MARK: - State Updates

    func updateTabState(
        tabID: UUID,
        url: URL?,
        title: String?,
        isLoading: Bool,
        canGoBack: Bool,
        canGoForward: Bool
    ) {
        guard let index = tabs.firstIndex(where: { $0.id == tabID }) else { return }

        var shouldPersist = false

        if let url, tabs[index].url != url {
            tabs[index].url = url
            shouldPersist = true
        }

        if let title, !title.isEmpty, tabs[index].title != title {
            tabs[index].title = title
        }

        if tabs[index].isLoading != isLoading {
            tabs[index].isLoading = isLoading
        }

        if tabs[index].canGoBack != canGoBack {
            tabs[index].canGoBack = canGoBack
        }

        if tabs[index].canGoForward != canGoForward {
            tabs[index].canGoForward = canGoForward
        }

        if shouldPersist {
            persistState()
        }
    }

    // MARK: - History

    func addHistoryEntry(url: URL, title: String?) {
        // Don't record private browsing
        if isPrivateMode || (selectedTab?.isPrivate ?? false) { return }

        let entry = HistoryEntry(url: url, title: title ?? url.absoluteString)

        if let latest = history.first,
           latest.url == entry.url,
           abs(latest.visitDate.timeIntervalSince(entry.visitDate)) < 3 {
            return
        }

        history.insert(entry, at: 0)

        if history.count > 500 {
            history = Array(history.prefix(500))
        }

        persistState()
    }

    // MARK: - Bookmarks

    func toggleBookmark() {
        guard let currentTab = selectedTab else { return }

        if let index = bookmarks.firstIndex(where: { $0.url == currentTab.url }) {
            bookmarks.remove(at: index)
        } else {
            bookmarks.append(Bookmark(url: currentTab.url, title: currentTab.title))
        }

        persistState()
    }

    // MARK: - Find

    func findInPage(text: String) {
        guard let selectedTabID else { return }
        let script = """
        window.find(\(javaScriptStringLiteral(text)), false, false, true, false, true, false);
        """
        webView(for: selectedTabID).evaluateJavaScript(script)
    }

    func clearFind() {
        guard let selectedTabID else { return }
        webView(for: selectedTabID).evaluateJavaScript("window.getSelection().removeAllRanges();")
    }

    // MARK: - Zoom

    func zoomIn() {
        adjustZoom(by: 0.1)
    }

    func zoomOut() {
        adjustZoom(by: -0.1)
    }

    func resetZoom() {
        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }
        webView.pageZoom = preferences.defaultZoom
        if let index = tabs.firstIndex(where: { $0.id == selectedTabID }) {
            tabs[index].zoomLevel = preferences.defaultZoom
        }
        if let host = selectedTab?.url.host {
            preferences.setZoomLevel(preferences.defaultZoom, for: host)
            savePreferences()
        }
    }

    private func adjustZoom(by delta: Double) {
        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }
        let newZoom = max(0.25, min(5.0, webView.pageZoom + delta))
        webView.pageZoom = newZoom
        if let index = tabs.firstIndex(where: { $0.id == selectedTabID }) {
            tabs[index].zoomLevel = newZoom
        }
        if let host = selectedTab?.url.host {
            preferences.setZoomLevel(newZoom, for: host)
            savePreferences()
        }
    }

    // MARK: - Reader Mode

    func toggleReaderMode() {
        if showReaderMode {
            showReaderMode = false
            readerTitle = nil
            readerContent = nil
            return
        }

        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }

        webView.evaluateJavaScript(ReaderView.extractionScript) { [weak self] result, error in
            guard let self, let jsonString = result as? String,
                  let data = jsonString.data(using: .utf8),
                  let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
                return
            }

            self.readerTitle = parsed["title"]
            self.readerContent = parsed["content"]
            self.showReaderMode = true
        }
    }

    // MARK: - Autocomplete

    func updateAutocomplete(query: String) {
        guard !query.isEmpty else {
            autocompleteResults = []
            showAutocomplete = false
            return
        }

        let lowered = query.lowercased()
        var results: [AutocompleteEntry] = []

        for bookmark in bookmarks {
            if bookmark.title.lowercased().contains(lowered) || bookmark.url.absoluteString.lowercased().contains(lowered) {
                results.append(AutocompleteEntry(title: bookmark.title, url: bookmark.url))
            }
            if results.count >= 8 { break }
        }

        if results.count < 8 {
            for entry in history {
                if entry.title.lowercased().contains(lowered) || entry.url.absoluteString.lowercased().contains(lowered) {
                    if !results.contains(where: { $0.url == entry.url }) {
                        results.append(AutocompleteEntry(title: entry.title, url: entry.url))
                    }
                }
                if results.count >= 8 { break }
            }
        }

        autocompleteResults = results
        showAutocomplete = !results.isEmpty
    }

    // MARK: - Tab Suspension

    private func checkTabSuspension(tabID: UUID, lastAccess: Date) {
        guard tabID != selectedTabID else { return }
        guard let index = tabs.firstIndex(where: { $0.id == tabID }) else { return }
        guard !tabs[index].isSuspended, !tabs[index].isPinned else { return }

        let threshold = TimeInterval(preferences.tabSuspensionMinutes * 60)
        if Date().timeIntervalSince(lastAccess) > threshold {
            // Save scroll position before suspending
            if let webView = webViews[tabID] {
                webView.evaluateJavaScript("window.pageYOffset") { [weak self] result, _ in
                    if let offset = result as? Double {
                        self?.tabs[index].scrollPosition = CGFloat(offset)
                        TabManager.shared.saveScrollPosition(CGFloat(offset), for: tabID)
                    }
                }
            }

            tabs[index].isSuspended = true
            webViews[tabID] = nil
        }
    }

    // MARK: - Print

    func printPage() {
        guard let selectedTabID, let webView = webViews[selectedTabID] else { return }
        let printInfo = NSPrintInfo.shared
        let printOperation = webView.printOperation(with: printInfo)
        printOperation.runModal(for: NSApp.keyWindow ?? NSWindow(), delegate: nil, didRun: nil, contextInfo: nil)
    }

    // MARK: - Persistence

    func persistState() {
        let tabData = tabs.filter { !$0.isPrivate }.map {
            TabData(
                id: $0.id,
                urlString: $0.url.absoluteString,
                title: $0.title,
                isPinned: $0.isPinned,
                scrollPosition: Double($0.scrollPosition),
                zoomLevel: $0.zoomLevel
            )
        }
        Storage.save(tabs: tabData, bookmarks: bookmarks, history: history, preferences: preferences)
    }

    func savePreferences() {
        Storage.savePreferences(preferences)
    }

    func saveCrashRecoveryState() {
        let tabData = tabs.filter { !$0.isPrivate }.map {
            TabData(
                id: $0.id,
                urlString: $0.url.absoluteString,
                title: $0.title,
                isPinned: $0.isPinned,
                scrollPosition: Double($0.scrollPosition),
                zoomLevel: $0.zoomLevel
            )
        }
        Storage.saveCrashRecoveryState(tabs: tabData, selectedTabID: selectedTabID)
    }

    func handleCleanShutdown() {
        Storage.markCleanShutdown()
        Storage.clearCrashRecoveryState()
        TabManager.shared.stopSuspensionTimer()
        TabManager.shared.stopCrashRecoveryTimer()

        if preferences.autoClearOnQuit {
            PrivacyManager.shared.clearOnQuit()
        }
    }

    // MARK: - Private Helpers

    private static func makeDefaultTab() -> Tab {
        Tab(url: URL.homeURL, title: "DuckDuckGo")
    }

    private static func makeTab(from data: TabData) -> Tab? {
        guard let url = URL(string: data.urlString) else { return nil }
        return Tab(
            id: data.id,
            url: url,
            title: data.title,
            isPinned: data.isPinned,
            scrollPosition: CGFloat(data.scrollPosition),
            zoomLevel: data.zoomLevel,
            isPrivate: data.isPrivate
        )
    }

    private func javaScriptStringLiteral(_ value: String) -> String {
        guard let data = try? JSONEncoder().encode(value),
              let encoded = String(data: data, encoding: .utf8) else {
            return "\"\""
        }
        return encoded
    }
}
