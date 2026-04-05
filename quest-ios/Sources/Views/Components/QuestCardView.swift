import SwiftUI

struct QuestCardView: View {
    let quest: Quest
    var onComplete: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            DifficultyBadgeView(rank: quest.difficulty)

            VStack(alignment: .leading, spacing: 4) {
                Text(quest.title)
                    .font(QuestTheme.bodyFont)
                    .foregroundStyle(QuestTheme.ink)
                    .strikethrough(quest.completed, color: QuestTheme.waxRed)

                HStack(spacing: 8) {
                    CategoryStampView(category: quest.category)
                    GoldCoinView(amount: quest.xpReward)
                }

                if !quest.notes.isEmpty {
                    Text(quest.notes)
                        .font(.caption)
                        .italic()
                        .foregroundStyle(QuestTheme.inkMuted)
                }

                if let due = quest.dueDate {
                    Text("Before the \(due.formatted(.dateTime.month(.wide).day())) moon")
                        .font(QuestTheme.labelFont)
                        .foregroundStyle(QuestTheme.goldDark)
                }
            }

            Spacer()

            if let onComplete {
                Button(action: onComplete) {
                    WaxSealView(text: "\u{2713}", size: 36)
                }
            }
        }
        .padding(12)
        .parchmentStyle()
    }
}
