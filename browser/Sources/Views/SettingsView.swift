import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState
        TabView {
            generalTab
                .tabItem { Label("General", systemImage: "gearshape") }
            privacyTab
                .tabItem { Label("Privacy", systemImage: "hand.raised") }
            contentBlockerTab
                .tabItem { Label("Content Blocker", systemImage: "shield") }
            extensionsTab
                .tabItem { Label("Extensions", systemImage: "puzzlepiece.extension") }
            syncTab
                .tabItem { Label("Sync", systemImage: "arrow.triangle.2.circlepath") }
        }
        .frame(width: 520, height: 400)
        .padding()
    }

    private var generalTab: some View {
        @Bindable var state = appState
        return Form {
            Picker("Search Engine", selection: Binding(
                get: { appState.preferences.searchEngine },
                set: { appState.preferences.searchEngine = $0; appState.savePreferences() }
            )) {
                ForEach(SearchEngine.allCases) { engine in
                    Text(engine.rawValue).tag(engine)
                }
            }

            TextField("Homepage", text: Binding(
                get: { appState.preferences.homepage },
                set: { appState.preferences.homepage = $0; appState.savePreferences() }
            ))

            TextField("Downloads Directory", text: Binding(
                get: { appState.preferences.downloadsDirectory },
                set: { appState.preferences.downloadsDirectory = $0; appState.savePreferences() }
            ))
            .help("Leave empty for default ~/Downloads")

            HStack {
                Text("Default Zoom")
                Slider(
                    value: Binding(
                        get: { appState.preferences.defaultZoom },
                        set: { appState.preferences.defaultZoom = $0; appState.savePreferences() }
                    ),
                    in: 0.5...3.0,
                    step: 0.1
                )
                Text("\(Int(appState.preferences.defaultZoom * 100))%")
                    .frame(width: 44, alignment: .trailing)
            }

            Toggle("Show Bookmark Bar", isOn: Binding(
                get: { appState.preferences.showBookmarkBar },
                set: { appState.preferences.showBookmarkBar = $0; appState.savePreferences() }
            ))

            Toggle("Show Start Page", isOn: Binding(
                get: { appState.preferences.startPageEnabled },
                set: { appState.preferences.startPageEnabled = $0; appState.savePreferences() }
            ))

            Toggle("Vertical Tabs", isOn: Binding(
                get: { appState.preferences.verticalTabs },
                set: { appState.preferences.verticalTabs = $0; appState.savePreferences() }
            ))

            Stepper(
                "Suspend inactive tabs after \(appState.preferences.tabSuspensionMinutes) min",
                value: Binding(
                    get: { appState.preferences.tabSuspensionMinutes },
                    set: { appState.preferences.tabSuspensionMinutes = $0; appState.savePreferences() }
                ),
                in: 1...60
            )
        }
        .padding()
    }

    private var privacyTab: some View {
        Form {
            Toggle("HTTPS-Only Mode", isOn: Binding(
                get: { appState.preferences.httpsOnlyMode },
                set: { appState.preferences.httpsOnlyMode = $0; appState.savePreferences() }
            ))
            .help("Automatically upgrade HTTP requests to HTTPS")

            Toggle("Auto-Clear Data on Quit", isOn: Binding(
                get: { appState.preferences.autoClearOnQuit },
                set: { appState.preferences.autoClearOnQuit = $0; appState.savePreferences() }
            ))

            TextField("Custom User Agent", text: Binding(
                get: { appState.preferences.customUserAgent },
                set: { appState.preferences.customUserAgent = $0; appState.savePreferences() }
            ))
            .help("Leave empty for default WebKit user agent")

            Section("Actions") {
                Button("Clear All Browsing Data") {
                    PrivacyManager.shared.clearBrowsingData()
                }

                Button("Clear History") {
                    appState.history.removeAll()
                    appState.persistState()
                }
            }
        }
        .padding()
    }

    private var contentBlockerTab: some View {
        Form {
            Toggle("Enable Content Blocker", isOn: Binding(
                get: { appState.preferences.contentBlockerEnabled },
                set: {
                    appState.preferences.contentBlockerEnabled = $0
                    appState.savePreferences()
                    if $0 {
                        PrivacyManager.shared.compileContentBlockerRules()
                    }
                }
            ))

            if appState.preferences.contentBlockerEnabled {
                Text("Blocking common ad and tracker domains using bundled rules.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let tab = appState.selectedTab {
                    let count = PrivacyManager.shared.trackerCount(for: tab.id)
                    Text("Trackers blocked on current page: \(count)")
                        .font(.callout)
                }
            }
        }
        .padding()
    }

    private var extensionsTab: some View {
        Form {
            Toggle("Enable Extensions", isOn: Binding(
                get: { appState.preferences.enableExtensions },
                set: {
                    appState.preferences.enableExtensions = $0
                    appState.savePreferences()
                    if $0 {
                        ExtensionManager.shared.loadExtensions()
                        ExtensionManager.shared.startBackgroundScripts()
                    } else {
                        ExtensionManager.shared.stopBackgroundScripts()
                    }
                }
            ))

            if appState.preferences.enableExtensions {
                let extensions = ExtensionManager.shared.extensions
                if extensions.isEmpty {
                    Text("No extensions installed.\nPlace extension folders in ~/Library/Application Support/Browser/Extensions/")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(extensions) { ext in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(ext.name)
                                    .font(.headline)
                                Text("v\(ext.version)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { ext.isEnabled },
                                set: { _ in ExtensionManager.shared.toggleExtension(id: ext.id) }
                            ))
                        }
                    }
                }
            }
        }
        .padding()
    }

    private var syncTab: some View {
        Form {
            Toggle("Enable iCloud Sync", isOn: Binding(
                get: { appState.preferences.enableSync },
                set: { appState.preferences.enableSync = $0; appState.savePreferences() }
            ))

            if appState.preferences.enableSync {
                if let lastSync = SyncManager.shared.lastSyncDate {
                    Text("Last synced: \(lastSync.formatted())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Button("Sync Now") {
                    Task {
                        await SyncManager.shared.syncBookmarks(appState.bookmarks)
                        await SyncManager.shared.syncOpenTabs(appState.tabs)
                    }
                }

                Text("Syncs bookmarks, open tabs, and preferences across your devices via iCloud.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
