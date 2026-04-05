import SwiftUI

struct XPBarView: View {
    let totalXP: Int

    var body: some View {
        let progress = XPEngine.xpProgress(totalXP)

        VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(QuestTheme.leather)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(QuestTheme.goldDark, lineWidth: 2)
                        )

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [QuestTheme.goldLight, QuestTheme.gold, QuestTheme.goldDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: geo.size.width * min(progress.percent / 100, 1))
                        .animation(.easeOut(duration: 0.6), value: totalXP)
                }
            }
            .frame(height: 20)

            Text("\(progress.progress) / \(progress.needed) XP")
                .font(QuestTheme.labelFont)
                .foregroundStyle(QuestTheme.gold)
        }
    }
}
