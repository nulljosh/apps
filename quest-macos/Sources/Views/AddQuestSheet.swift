import SwiftUI

struct AddQuestSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var difficulty: DifficultyRank = .C
    @State private var category: QuestCategory = .personal
    @State private var dueDate: Date?
    @State private var hasDueDate = false
    @State private var notes = ""

    var body: some View {
        Form {
            Section {
                TextField("Quest name", text: $title)
            } header: {
                Text("Quest Name")
            }

            Section {
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(DifficultyRank.allCases) { rank in
                        Text("\(rank.rawValue) (\(rank.xpReward) XP)").tag(rank)
                    }
                }
            }

            Section {
                Picker("Category", selection: $category) {
                    ForEach(QuestCategory.allCases) { cat in
                        Text(cat.label).tag(cat)
                    }
                }
            }

            Section {
                Toggle("Set due date", isOn: $hasDueDate)
                if hasDueDate {
                    DatePicker("Due date", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: .date)
                }
            }

            Section {
                TextField("Additional details...", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            } header: {
                Text("Notes")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("New Quest")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Discard") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Inscribe") {
                    let quest = Quest(
                        title: title.trimmingCharacters(in: .whitespaces),
                        difficulty: difficulty,
                        category: category,
                        notes: notes.trimmingCharacters(in: .whitespaces),
                        dueDate: hasDueDate ? dueDate : nil
                    )
                    context.insert(quest)
                    dismiss()
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                .keyboardShortcut(.return, modifiers: .command)
            }
        }
    }
}
