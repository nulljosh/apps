import SwiftUI

struct JournalView: View {
    @Environment(Store.self) private var store
    @State private var showingForm = false
    @State private var editingEntry: JournalEntry? = nil
    @State private var newDate = Date.now
    @State private var newText = ""

    private let seedDates: Set<String> = Set(journalSeed.map(\.date))

    private func fmt(_ iso: String) -> String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        guard let d = f.date(from: iso) else { return iso }
        let o = DateFormatter(); o.dateStyle = .medium; o.timeStyle = .none
        return o.string(from: d).uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Pain Journal")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("+ Entry") { showingForm = true }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.briefGreen)
            }
            .padding(.bottom, 14)

            ForEach(Array(store.journalEntries.enumerated()), id: \.element.id) { idx, entry in
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(fmt(entry.date))
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundStyle(.secondary)
                        Text(entry.text)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                    }
                    Spacer()
                    if !seedDates.contains(entry.date) {
                        HStack(spacing: 8) {
                            Button {
                                editingEntry = entry
                                newDate = {
                                    let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
                                    return f.date(from: entry.date) ?? Date.now
                                }()
                                newText = entry.text
                                showingForm = true
                            } label: { Image(systemName: "pencil").font(.system(size: 11)) }
                                .buttonStyle(.plain).foregroundStyle(.secondary)

                            Button {
                                Task { await store.deleteJournalEntry(date: entry.date) }
                            } label: { Image(systemName: "trash").font(.system(size: 11)) }
                                .buttonStyle(.plain).foregroundStyle(.briefDanger)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.vertical, 14)
                if idx < store.journalEntries.count - 1 { Divider() }
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showingForm, onDismiss: { editingEntry = nil; newText = "" }) {
            NavigationStack {
                Form {
                    Section("Date") {
                        DatePicker("Entry date", selection: $newDate, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    Section("Note") {
                        TextEditor(text: $newText)
                            .frame(minHeight: 100)
                    }
                }
                .navigationTitle(editingEntry == nil ? "New Entry" : "Edit Entry")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingForm = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            guard !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                            let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
                            let d = f.string(from: newDate); let t = newText
                            showingForm = false
                            Task { await store.addJournalEntry(date: d, text: t) }
                        }
                    }
                }
            }
            .frame(minWidth: 420, minHeight: 380)
        }
    }
}
