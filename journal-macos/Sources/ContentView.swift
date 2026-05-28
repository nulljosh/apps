import SwiftUI

struct ContentView: View {
    @StateObject private var store = FeedStore()

    var body: some View {
        NavigationSplitView {
            Group {
                if store.posts.isEmpty {
                    placeholder
                } else {
                    List(store.posts) { post in
                        NavigationLink {
                            PostDetailView(post: post)
                        } label: {
                            PostRow(post: post)
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                Button {
                    Task { await store.load() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(store.isLoading)
            }
            .refreshable { await store.load() }
        } detail: {
            ContentUnavailableView("Select a post", systemImage: "doc.text")
        }
        .task { if store.posts.isEmpty { await store.load() } }
    }

    @ViewBuilder
    private var placeholder: some View {
        if store.isLoading {
            ProgressView("Loading")
        } else if let error = store.errorMessage {
            ContentUnavailableView {
                Label("Could not load", systemImage: "wifi.exclamationmark")
            } description: {
                Text(error)
            } actions: {
                Button("Retry") { Task { await store.load() } }
            }
        } else {
            ContentUnavailableView("No posts", systemImage: "tray")
        }
    }
}

struct PostRow: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.title)
                .font(.headline)
            if !post.displayDate.isEmpty {
                Text(post.displayDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(post.excerpt)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
