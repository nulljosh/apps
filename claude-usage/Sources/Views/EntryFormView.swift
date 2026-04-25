import SwiftUI

struct EntryFormView: View {
    @Environment(UsageStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let entry: UsageEntry?

    @State private var provider: AIProvider = .claude
    @State private var date: Date = Date()
    @State private var conversations: String = ""
    @State private var tokensEstimate: String = ""
    @State private var costEstimate: String = ""
    @State private var model: String = ""
    @State private var notes: String = ""

    private var isEditing: Bool { entry != nil }
    private var title: String { isEditing ? "Edit Entry" : "New Entry" }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Button("Cancel") { dismiss() }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
            }
            .padding(20)

            Divider()

            Form {
                Section {
                    Picker("Provider", selection: $provider) {
                        ForEach(AIProvider.allCases) { p in
                            Text(p.displayName).tag(p)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Model (e.g. claude-opus-4)", text: $model)
                }

                Section("Activity") {
                    TextField("Conversations", text: $conversations)
                        .help("Number of conversation sessions")
                    TextField("Tokens (estimate)", text: $tokensEstimate)
                        .help("Approximate total tokens used")
                    TextField("Cost estimate", text: $costEstimate)
                        .help("In your configured currency")
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                }
            }
            .formStyle(.grouped)

            Divider()

            HStack {
                if isEditing {
                    Button("Delete", role: .destructive) {
                        if let e = entry { store.delete(e) }
                        dismiss()
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.red)
                }
                Spacer()
                Button("Save") { save() }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.return, modifiers: .command)
            }
            .padding(20)
        }
        .frame(width: 420)
        .onAppear { loadEntry() }
    }

    private func loadEntry() {
        if let e = entry {
            provider = e.provider
            date = e.date
            conversations = e.conversations > 0 ? "\(e.conversations)" : ""
            tokensEstimate = e.tokensEstimate > 0 ? "\(e.tokensEstimate)" : ""
            costEstimate = e.costEstimate > 0 ? String(format: "%.2f", e.costEstimate) : ""
            model = e.model
            notes = e.notes
        } else {
            provider = store.settings.defaultProvider
        }
    }

    private func save() {
        let newEntry = UsageEntry(
            id: entry?.id ?? UUID(),
            provider: provider,
            date: date,
            conversations: Int(conversations) ?? 0,
            tokensEstimate: Int(tokensEstimate) ?? 0,
            costEstimate: Double(costEstimate) ?? 0,
            model: model.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            createdAt: entry?.createdAt ?? Date()
        )
        if isEditing {
            store.update(newEntry)
        } else {
            store.add(newEntry)
        }
        dismiss()
    }
}
