import SwiftUI

struct WaxSealView: View {
    let text: String
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [QuestTheme.waxRedLight, QuestTheme.waxRed],
                        center: .init(x: 0.35, y: 0.35),
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.3), radius: 3, y: 2)

            Text(text)
                .font(.system(size: size * 0.35, weight: .bold, design: .serif))
                .foregroundStyle(QuestTheme.parchmentDark)
        }
    }
}
