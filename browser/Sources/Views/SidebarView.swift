import SwiftUI
import UniformTypeIdentifiers

struct SidebarView: View {
    @Bindable var appState: AppState
    @State private var historySearch = ""
    @State private var expandedFolders: Set<String> = ["Favorites", "Bookmarks"]

    private var bookmarkFolders: [String: [Bookmark]] {
        Dictionary(grouping: appState.bookmarks, by: { $0.folder })
    }

    private var filteredHistory: [HistoryEntry] {
        if historySearch.isEmpty {
            return Array(appState.history.prefix(50))
        }
        let lowered = historySearch.lowercased()
        return appState.history.filter {
            $0.title.lowercased().contains(lowered) || $0.url.absoluteString.lowercased().contains(lowered)
        }.prefix(50).map { $0 }
    }

    var body: some View {
        List {
            Section("Bookmarks") {
                ForEach(bookmarkFolders.keys.sorted(), id: \.self) { folder in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedFolders.contains(folder) },
                            set: { if $0 { expandedFolders.insert(folder) } else { expandedFolders.remove(folder) } }
                        )
                    ) {
                        ForEach(bookmarkFolders[folder] ?? []) { bookmark in
                            Button {
                                appState.openInSelectedTab(bookmark.url)
                            } label: {
                                sidebarRow(
                                    title: bookmark.title,
                                    url: bookmark.url,
                                    icon: "bookmark"
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Open in New Tab") {
                                    appState.addTab(url: bookmark.url)
                                }
                                Button("Delete Bookmark", role: .destructive) {
                                    appState.bookmarks.removeAll { $0.id == bookmark.id }
                                    appState.persistState()
                                }
                            }
                        }
                    } label: {
                        Label(folder, systemImage: "folder")
                    }
                }

                Divider()

                HStack(spacing: 8) {
                    Button("Import") {
                        importBookmarks()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)

                    Button("Export") {
                        exportBookmarks()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
                .padding(.vertical, 4)
            }

            Section("History") {
                TextField("Search history...", text: $historySearch)
                    .textFieldStyle(.roundedBorder)
                    .font(.caption)

                ForEach(filteredHistory) { entry in
                    Button {
                        appState.openInSelectedTab(entry.url)
                    } label: {
                        sidebarRow(
                            title: entry.title,
                            url: entry.url,
                            icon: "clock.arrow.circlepath"
                        )
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Open in New Tab") {
                            appState.addTab(url: entry.url)
                        }

                        Button("Clear History", role: .destructive) {
                            appState.history.removeAll()
                            appState.persistState()
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }

    private func sidebarRow(title: String, url: URL, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .lineLimit(1)

                Text(url.host ?? url.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }

    // MARK: - Import / Export

    private func importBookmarks() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.html]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK, let url = panel.url else { return }
        guard let htmlString = try? String(contentsOf: url, encoding: .utf8) else { return }

        let imported = Storage.importBookmarksHTML(htmlString)
        appState.bookmarks.append(contentsOf: imported)
        appState.persistState()
    }

    private func exportBookmarks() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType.html]
        panel.nameFieldStringValue = "bookmarks.html"

        guard panel.runModal() == .OK, let url = panel.url else { return }

        let html = Storage.exportBookmarksHTML(appState.bookmarks)
        try? html.write(to: url, atomically: true, encoding: .utf8)
    }
}
