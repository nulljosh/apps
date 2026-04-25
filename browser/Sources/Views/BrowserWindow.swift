import SwiftUI

struct BrowserWindow: View {
    @Environment(AppState.self) private var appState
    @State private var showSidebar = true
    @State private var focusAddressBar = false

    var body: some View {
        VStack(spacing: 0) {
            if appState.preferences.verticalTabs {
                horizontalAddressArea
                Divider()

                if appState.showFindBar {
                    findBar
                    Divider()
                }

                HSplitView {
                    verticalTabBar
                        .frame(minWidth: 180, idealWidth: 220, maxWidth: 280)

                    mainContent
                }
            } else {
                TabBarView(appState: appState)
                Divider()
                horizontalAddressArea
                Divider()

                if appState.showFindBar {
                    findBar
                    Divider()
                }

                if appState.preferences.showBookmarkBar && !appState.bookmarks.isEmpty {
                    bookmarkBar
                    Divider()
                }

                HSplitView {
                    if showSidebar {
                        SidebarView(appState: appState)
                            .frame(minWidth: 220, idealWidth: 260, maxWidth: 320)
                    }

                    mainContent
                }
            }

            Divider()
            statusBar
        }
        .background(keyboardShortcutButtons)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    showSidebar.toggle()
                } label: {
                    Image(systemName: "sidebar.leading")
                }
                .help("Toggle Sidebar")
            }
        }
    }

    // MARK: - Address Bar Area

    private var horizontalAddressArea: some View {
        AddressBarView(appState: appState, focusAddressBar: $focusAddressBar)
    }

    // MARK: - Main Content

    @ViewBuilder
    private var mainContent: some View {
        ZStack {
            if appState.showReaderMode {
                ReaderView()
                    .environment(appState)
            } else if let selectedTabID = appState.selectedTabID {
                if appState.preferences.startPageEnabled,
                   let tab = appState.tab(for: selectedTabID),
                   isStartPageURL(tab.url) {
                    StartPageView()
                        .environment(appState)
                } else {
                    WebViewWrapper(appState: appState, tabID: selectedTabID)
                        .id(selectedTabID)
                }
            } else {
                ContentUnavailableView("No Tab", systemImage: "macwindow")
            }
        }
    }

    private func isStartPageURL(_ url: URL) -> Bool {
        let homeURLs: Set<String> = [
            "https://duckduckgo.com",
            "https://www.google.com",
            "https://www.bing.com",
            "https://www.ecosia.org"
        ]
        return url == appState.preferences.searchEngine.homeURL || homeURLs.contains(url.absoluteString)
    }

    // MARK: - Vertical Tab Bar

    private var verticalTabBar: some View {
        VStack(spacing: 0) {
            List(selection: Binding(
                get: { appState.selectedTabID },
                set: { if let id = $0 { appState.selectTab(id: id) } }
            )) {
                if !appState.pinnedTabs.isEmpty {
                    Section("Pinned") {
                        ForEach(appState.pinnedTabs) { tab in
                            verticalTabRow(for: tab)
                                .tag(tab.id)
                        }
                    }
                }

                Section("Tabs") {
                    ForEach(appState.unpinnedTabs) { tab in
                        verticalTabRow(for: tab)
                            .tag(tab.id)
                    }
                }
            }
            .listStyle(.sidebar)

            Divider()

            Button {
                appState.addTab()
            } label: {
                Label("New Tab", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .padding(8)
        }
        .background(.quaternary.opacity(0.15))
    }

    private func verticalTabRow(for tab: Tab) -> some View {
        HStack(spacing: 6) {
            if let favicon = tab.favicon {
                Image(nsImage: favicon)
                    .resizable()
                    .frame(width: 14, height: 14)
            } else {
                Image(systemName: tab.isLoading ? "arrow.triangle.2.circlepath" : "globe")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Text(tab.title)
                .font(.system(size: 12))
                .lineLimit(1)

            Spacer(minLength: 0)

            if tab.isPlayingAudio {
                Image(systemName: tab.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        appState.toggleMuteTab(id: tab.id)
                    }
            }

            if tab.isSuspended {
                Image(systemName: "moon.zzz")
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
            }
        }
        .contextMenu {
            Button("Pin Tab") { appState.togglePinTab(id: tab.id) }
            Button("Close Tab") { appState.closeTab(id: tab.id) }
        }
    }

    // MARK: - Bookmark Bar

    private var bookmarkBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(appState.bookmarks.prefix(12)) { bookmark in
                    Button {
                        appState.openInSelectedTab(bookmark.url)
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                            Text(bookmark.title)
                                .font(.system(size: 11))
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.quaternary.opacity(0.3))
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
        }
        .background(.bar)
    }

    // MARK: - Find Bar

    private var findBar: some View {
        HStack(spacing: 8) {
            TextField("Find in page", text: Binding(
                get: { appState.findText },
                set: { appState.findText = $0 }
            ))
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    appState.findInPage(text: appState.findText)
                }

            Button("Find") {
                appState.findInPage(text: appState.findText)
            }

            Button {
                appState.showFindBar = false
                appState.clearFind()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
            .help("Close Find Bar")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial)
    }

    // MARK: - Status Bar

    private var statusBar: some View {
        HStack {
            Text(statusText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)

            Spacer(minLength: 0)

            if let tab = appState.selectedTab {
                let trackerCount = PrivacyManager.shared.trackerCount(for: tab.id)
                if trackerCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 10))
                        Text("\(trackerCount) blocked")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }

            if let tab = appState.selectedTab {
                let zoomPct = Int(tab.zoomLevel * 100)
                if zoomPct != 100 {
                    Text("\(zoomPct)%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 22)
        .background(.bar)
    }

    private var statusText: String {
        appState.selectedTab?.url.absoluteString ?? ""
    }

    // MARK: - Keyboard Shortcuts

    private var keyboardShortcutButtons: some View {
        ZStack {
            shortcutButton("New Tab", key: "t") {
                appState.addTab()
            }

            shortcutButton("Close Tab", key: "w") {
                guard let selectedTabID = appState.selectedTabID else { return }
                appState.closeTab(id: selectedTabID)
            }

            shortcutButton("Reload", key: "r") {
                appState.reload()
            }

            shortcutButton("Focus Address Bar", key: "l") {
                focusAddressBar = false
                DispatchQueue.main.async {
                    focusAddressBar = true
                }
            }

            shortcutButton("Back", key: "[") {
                appState.goBack()
            }

            shortcutButton("Forward", key: "]") {
                appState.goForward()
            }

            shortcutButton("Find", key: "f") {
                appState.showFindBar.toggle()
                if !appState.showFindBar {
                    appState.clearFind()
                }
            }

            // Reopen closed tab: Cmd+Shift+T
            shortcutButton("Reopen Tab", key: "t", modifiers: [.command, .shift]) {
                appState.reopenClosedTab()
            }

            // Private window: Cmd+Shift+N
            shortcutButton("Private Window", key: "n", modifiers: [.command, .shift]) {
                appState.isPrivateMode = true
                appState.addTab(isPrivate: true)
            }

            // Reader mode: Cmd+Shift+R
            shortcutButton("Reader Mode", key: "r", modifiers: [.command, .shift]) {
                appState.toggleReaderMode()
            }

            // Pin tab: Cmd+Shift+P
            shortcutButton("Pin Tab", key: "p", modifiers: [.command, .shift]) {
                guard let id = appState.selectedTabID else { return }
                appState.togglePinTab(id: id)
            }

            // Print: Cmd+P
            shortcutButton("Print", key: "p") {
                appState.printPage()
            }

            // Zoom in: Cmd+=
            shortcutButton("Zoom In", key: "=") {
                appState.zoomIn()
            }

            // Zoom out: Cmd+-
            shortcutButton("Zoom Out", key: "-") {
                appState.zoomOut()
            }

            // Reset zoom: Cmd+0
            shortcutButton("Reset Zoom", key: "0") {
                appState.resetZoom()
            }

            ForEach(1...9, id: \.self) { number in
                shortcutButton("Select Tab \(number)", key: KeyEquivalent(Character("\(number)"))) {
                    selectTab(number: number)
                }
            }
        }
        .frame(width: 0, height: 0)
        .opacity(0)
        .accessibilityHidden(true)
    }

    private func shortcutButton(
        _ title: String,
        key: KeyEquivalent,
        modifiers: EventModifiers = .command,
        action: @escaping () -> Void
    ) -> some View {
        Button(title, action: action)
            .keyboardShortcut(key, modifiers: modifiers)
    }

    private func selectTab(number: Int) {
        guard !appState.tabs.isEmpty else { return }
        let index = number == 9 ? appState.tabs.count - 1 : number - 1
        guard appState.tabs.indices.contains(index) else { return }
        appState.selectTab(id: appState.tabs[index].id)
    }
}
