import SwiftUI

struct LeatherBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(QuestTheme.leather)
    }
}

extension View {
    func leatherStyle() -> some View {
        modifier(LeatherBackground())
    }
}
