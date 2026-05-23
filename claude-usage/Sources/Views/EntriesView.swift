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

        Table(displayedEntries) {
            TableColumn("Date") { entry in
                Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.subheadline)
            }
            .width(100)

            TableColumn("Provider") { entry in
                HStack(spacing: 6) {
                    Circle()
                        .fill(providerColor(entry.provider))
                        .frame(width: 8, height: 8)
                    Text(entry.provider.displayName)
                        .font(.subheadline)
                }
            }
            .width(90)

            TableColumn("Model") { entry in
                Text(entry.model.isEmpty ? "-" : entry.model)
                    .font(.subheadline)
                    .foregroundStyle(entry.model.isEmpty ? .secondary : .primary)
            }
            .width(120)

            TableColumn("Convos") { entry in
                Text("\(entry.conversations)")
                    .font(.subheadline.monospacedDigit())
            }
            .width(60)

            TableColumn("Tokens") { entry in
                Text(formatTokens(entry.tokensEstimate))
                    .font(.subheadline.monospacedDigit())
            }
            .width(80)

            TableColumn("Cost") { entry in
                Text(String(format: "$%.2f", entry.costEstimate))
                    .font(.subheadline.monospacedDigit())
            }
            .width(70)

            TableColumn("Notes") { entry in
                Text(entry.notes.isEmpty ? "-" : entry.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .contextMenu(forSelectionType: UsageEntry.ID.self) { ids in
            if let id = ids.first, let entry = store.entries.first(where: { $0.id == id }) {
                Button("Edit") { store.editingEntry = entry }
                Divider()
                Button("Delete", role: .destructive) { store.delete(entry) }
            }
        }
        .searchable(text: $searchText, placement: .toolbar)
        .navigationTitle("Entries")
        .navigationSubtitle("\(displayedEntries.count) entries")
        .toolbar {
            ToolbarItem {
                Button(action: { store.showingAddEntry = true }) {
                    Label("Add Entry", systemImage: "plus")
                }
            }
        }
    }

    private func formatTokens(_ n: Int) -> String {
        if n >= 1_000_000 { return String(format: "%.1fM", Double(n) / 1_000_000) }
        if n >= 1_000 { return String(format: "%.1fK", Double(n) / 1_000) }
        return "\(n)"
    }

    private func providerColor(_ provider: AIProvider) -> Color {
        switch provider {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }
}

struct EntryRow: View {
    @Environment(UsageStore.self) private var store
    let entry: UsageEntry

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(providerColor)
                        .frame(width: 8, height: 8)
                    Text(entry.provider.displayName)
                        .font(.subheadline.weight(.medium))
                    if !entry.model.isEmpty {
                        Text(entry.model)
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

            VStack(alignment: .trailing, spacing: 2) {
                Text(entry.date, format: .dateTime.month(.abbreviated).day())
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(String(format: "$%.2f", entry.costEstimate))
                    .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { store.editingEntry = entry }
    }

    private var providerColor: Color {
        switch entry.provider {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }
}
