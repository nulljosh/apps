import SwiftUI

struct StartPageView: View {
    @Environment(AppState.self) private var appState

    private var recentHistory: [HistoryEntry] {
        var seen = Set<String>()
        return appState.history.filter { entry in
            let host = entry.url.host ?? entry.url.absoluteString
            if seen.contains(host) { return false }
            seen.insert(host)
            return true
        }.prefix(12).map { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)

                Text("Browser")
                    .font(.system(size: 36, weight: .bold, design: .default))
                    .foregroundStyle(.primary)

                searchField

                if !appState.bookmarks.isEmpty {
                    bookmarksGrid
                }

                if !recentHistory.isEmpty {
                    recentGrid
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            Text("Search or enter website name")
                .foregroundStyle(.tertiary)
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: 560)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }

    private var bookmarksGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bookmarks")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                ForEach(appState.bookmarks.prefix(8)) { bookmark in
                    Button {
                        appState.openInSelectedTab(bookmark.url)
                    } label: {
                        startPageTile(
                            title: bookmark.title,
                            host: bookmark.url.host ?? "",
                            icon: "bookmark.fill"
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: 600)
    }

    private var recentGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Visited")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                ForEach(recentHistory) { entry in
                    Button {
                        appState.openInSelectedTab(entry.url)
                    } label: {
                        startPageTile(
                            title: entry.title,
                            host: entry.url.host ?? "",
                            icon: "clock"
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: 600)
    }

    private func startPageTile(title: String, host: String, icon: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.quaternary)
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .font(.caption)
                .lineLimit(1)
                .foregroundStyle(.primary)

            Text(host)
                .font(.caption2)
                .lineLimit(1)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
        )
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}
