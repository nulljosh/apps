import SwiftUI

struct CompletionOverlay: View {
    let result: CompletionResult
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if result.levelUp {
                WaxSealView(text: "\(result.newLevel)", size: 80)

                Text("Level Up!")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(QuestTheme.goldDark)

                Text(result.newTitle)
                    .font(QuestTheme.headingFont)
                    .foregroundStyle(QuestTheme.ink)

                Text("You have reached Level \(result.newLevel)")
                    .font(QuestTheme.bodyFont)
                    .foregroundStyle(QuestTheme.inkMuted)
            } else {
                WaxSealView(text: "\u{2713}", size: 56)

                Text(result.questTitle)
                    .font(QuestTheme.headingFont)
                    .foregroundStyle(QuestTheme.ink)

                GoldCoinView(amount: result.xpEarned)

                Divider().overlay(QuestTheme.goldDark).padding(.horizontal, 32)

                if result.rewardGranted, let rewardText = result.rewardText {
                    Text("The fates bestow a boon")
                        .font(QuestTheme.labelFont)
                        .tracking(1.5)
                        .textCase(.uppercase)
                        .foregroundStyle(QuestTheme.inkMuted)

                    Text(rewardText)
                        .font(QuestTheme.bodyFont)
                        .italic()
                        .foregroundStyle(QuestTheme.ink)
                } else {
                    Text("The gods demand more... No reward this time.")
                        .font(QuestTheme.bodyFont)
                        .italic()
                        .foregroundStyle(QuestTheme.inkMuted)
                }
            }

            Button("Continue", action: onDismiss)
                .font(QuestTheme.statsFont)
                .keyboardShortcut(.return)
                .padding(.top, 8)
        }
        .padding(32)
        .background(QuestTheme.parchment)
    }
}
