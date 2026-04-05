import SwiftUI

struct CategoryStampView: View {
    let category: QuestCategory

    private var color: Color {
        switch category {
        case .fitness: QuestTheme.waxRedLight
        case .study: .blue
        case .work: QuestTheme.agedGreen
        case .personal: QuestTheme.goldDark
        case .creative: .purple
        case .errand: .brown
        }
    }

    var body: some View {
        Text(category.label)
            .font(.system(size: 9, weight: .medium, design: .serif))
            .tracking(0.5)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .overlay(
                Capsule().stroke(color, lineWidth: 1.5)
            )
    }
}
