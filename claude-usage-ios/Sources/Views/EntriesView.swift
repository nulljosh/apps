import SwiftUI

struct EntriesView: View {
    @Environment(UsageStore.self) private var store
    @State private var searchText = ""

    private var displayedEntries: [UsageEntry] {
        let base = store.filteredEntries
        guard !searchText.isEmpty else { return base }
        let q = searchText.lowercased()
        return base.filter {
            $0.provider.displayName.lowercased().contains(q) ||
            $0.model.lowercased().contains(q) ||
            $0.notes.lowercased().contains(q)
        }
    }

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            Group {
                if displayedEntries.isEmpty && searchText.isEmpty && store.entries.isEmpty {
                    ContentUnavailableView(
                        "No entries",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Tap + to log your first session.")
                    )
                } else {
                    List {
                        // Provider filter chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ProviderChip(label: "All", active: store.selectedProvider == nil) {
                                    store.selectedProvider = nil
                                }
                                ForEach(AIProvider.allCases) { p in
                                    ProviderChip(label: p.displayName, color: p.color, active: store.selectedProvider == p) {
                                        store.selectedProvider = p
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                        ForEach(displayedEntries) { entry in
                            EntryListRow(entry: entry)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", role: .destructive) { store.delete(entry) }
                                }
                                .swipeActions(edge: .leading) {
                                    Button("Edit") { store.editingEntry = entry }
                                        .tint(.blue)
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Entries")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { store.showingAddEntry = true }) {
                        Image(systemName: "plus").fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct ProviderChip: View {
    let label: String
    var color: Color = .accentColor
    let active: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(active ? color : Color.secondary.opacity(0.12))
                .foregroundStyle(active ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct EntryListRow: View {
    @Environment(UsageStore.self) private var store
    let entry: UsageEntry

    var body: some View {
        Button(action: { store.editingEntry = entry }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(entry.provider.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: entry.provider.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(entry.provider.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(entry.provider.displayName)
                            .font(.subheadline.weight(.semibold))
                        if !entry.model.isEmpty {
                            Text(entry.model)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    HStack(spacing: 8) {
                        Text("\(entry.conversations) convos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if entry.tokensEstimate > 0 {
                            Text(formatTokens(entry.tokensEstimate))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if !entry.notes.isEmpty {
                        Text(entry.notes)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text(entry.date, format: .dateTime.month(.abbreviated).day())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.2f", entry.costEstimate))
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                }
            }
            .padding(.vertical, 6)
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }

    private func formatTokens(_ n: Int) -> String {
        if n >= 1_000_000 { return String(format: "%.1fM", Double(n) / 1_000_000) }
        if n >= 1_000 { return String(format: "%.1fK", Double(n) / 1_000) }
        return "\(n)"
    }
}
