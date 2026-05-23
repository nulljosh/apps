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
    @State private var showDeleteConfirm = false

    private var isEditing: Bool { entry != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Provider", selection: $provider) {
                        ForEach(AIProvider.allCases) { p in
                            HStack {
                                Circle().fill(p.color).frame(width: 8, height: 8)
                                Text(p.displayName)
                            }
                            .tag(p)
                        }
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    TextField("Model", text: $model, prompt: Text("e.g. claude-opus-4"))
                }

                Section("Activity") {
                    TextField("Conversations", text: $conversations, prompt: Text("0"))
                        .keyboardType(.numberPad)
                    TextField("Tokens (estimate)", text: $tokensEstimate, prompt: Text("0"))
                        .keyboardType(.numberPad)
                    TextField("Cost estimate", text: $costEstimate, prompt: Text("0.00"))
                        .keyboardType(.decimalPad)
                }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if isEditing {
                    Section {
                        Button("Delete Entry", role: .destructive) {
                            showDeleteConfirm = true
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Entry" : "New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
            .confirmationDialog("Delete this entry?", isPresented: $showDeleteConfirm) {
                Button("Delete", role: .destructive) {
                    if let e = entry { store.delete(e) }
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
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
        if isEditing { store.update(newEntry) } else { store.add(newEntry) }
        dismiss()
    }
}
