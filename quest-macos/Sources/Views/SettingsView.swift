import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var rewards: [Reward]
    @State private var newRewardText = ""

    var body: some View {
        List {
            Section {
                Text("When a quest is completed, the fates may bestow one of these rewards upon thee.")
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.secondary)

                HStack {
                    TextField("e.g. Take a coffee break", text: $newRewardText)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        let reward = Reward(text: newRewardText.trimmingCharacters(in: .whitespaces))
                        context.insert(reward)
                        newRewardText = ""
                    }
                    .disabled(newRewardText.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ForEach(rewards) { reward in
                    Text(reward.text)
                }
                .onDelete { offsets in
                    for index in offsets {
                        context.delete(rewards[index])
                    }
                }
            } header: {
                Text("Boons & Pleasures")
            }
        }
        .navigationTitle("Settings")
    }
}
