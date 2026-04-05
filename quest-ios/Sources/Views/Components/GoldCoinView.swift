import SwiftUI

struct GoldCoinView: View {
    let amount: Int

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [QuestTheme.goldLight, QuestTheme.goldDark],
                        center: .init(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: 10
                    )
                )
                .frame(width: 16, height: 16)
                .overlay(
                    Text("\u{2605}")
                        .font(.system(size: 8))
                        .foregroundStyle(QuestTheme.leatherDark)
                )

            Text("\(amount)")
                .font(QuestTheme.labelFont)
                .foregroundStyle(QuestTheme.gold)
        }
    }
}
