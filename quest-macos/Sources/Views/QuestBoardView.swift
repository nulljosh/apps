import SwiftUI
import SwiftData

struct QuestBoardView: View {
    let profile: CharacterProfile
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Quest> { !$0.completed }, sort: \Quest.createdAt, order: .reverse) private var activeQuests: [Quest]
    @Query(filter: #Predicate<Quest> { $0.completed }, sort: \Quest.completedAt, order: .reverse) private var completedQuests: [Quest]
    @Query private var rewards: [Reward]
    @State private var showAdd = false
    @State private var completionResult: CompletionResult?
    @State private var showCompleted = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Section {
                    if activeQuests.isEmpty {
                        Text("No active quests. The realm is at peace... for now.")
                            .font(QuestTheme.bodyFont)
                            .italic()
                            .foregroundStyle(QuestTheme.inkMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                    }
                    ForEach(activeQuests) { quest in
                        QuestCardView(quest: quest) {
                            completeQuest(quest)
                        }
                    }
                } header: {
                    SectionLabel(text: "Active Quests (\(activeQuests.count))")
                }

                if !completedQuests.isEmpty {
                    Section {
                        if showCompleted {
                            ForEach(completedQuests) { quest in
                                QuestCardView(quest: quest, onComplete: nil)
                                    .opacity(0.6)
                            }
                        }
                    } header: {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showCompleted.toggle()
                            }
                        } label: {
                            SectionLabel(text: "Completed (\(completedQuests.count)) \(showCompleted ? "\u{25B2}" : "\u{25BC}")")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(24)
        }
        .background(QuestTheme.leatherDark)
        .navigationTitle("Quest Board")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAdd = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(QuestTheme.gold)
                        .font(.title2)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
        .sheet(isPresented: $showAdd) {
            AddQuestSheet()
                .frame(minWidth: 400, minHeight: 450)
        }
        .sheet(item: $completionResult) { result in
            CompletionOverlay(result: result) {
                completionResult = nil
            }
            .frame(minWidth: 380, minHeight: 400)
        }
    }

    private func completeQuest(_ quest: Quest) {
        let oldLevel = profile.level
        quest.completed = true
        quest.completedAt = Date()
        profile.addXP(quest.xpReward)
        profile.updateStreak()
        let newLevel = profile.level
        let rewardResult = RewardEngine.rollReward(rewards)
        completionResult = CompletionResult(
            questTitle: quest.title,
            xpEarned: quest.xpReward,
            rewardGranted: rewardResult.granted,
            rewardText: rewardResult.reward?.text,
            levelUp: newLevel > oldLevel,
            newLevel: newLevel,
            newTitle: XPEngine.getTitle(newLevel)
        )
    }
}

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(QuestTheme.labelFont)
            .tracking(1.5)
            .textCase(.uppercase)
            .foregroundStyle(QuestTheme.parchmentDark)
    }
}

struct CompletionResult: Identifiable {
    let id = UUID()
    let questTitle: String
    let xpEarned: Int
    let rewardGranted: Bool
    let rewardText: String?
    let levelUp: Bool
    let newLevel: Int
    let newTitle: String
}
