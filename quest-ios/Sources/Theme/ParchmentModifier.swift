import SwiftUI

struct ParchmentBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(QuestTheme.parchment)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: QuestTheme.ink.opacity(0.3), radius: 4, y: 2)
    }
}

extension View {
    func parchmentStyle() -> some View {
        modifier(ParchmentBackground())
    }
}
