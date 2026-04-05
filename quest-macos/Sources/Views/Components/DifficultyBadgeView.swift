import SwiftUI

struct DifficultyBadgeView: View {
    let rank: DifficultyRank

    private var color: Color {
        switch rank {
        case .F: .gray
        case .D: QuestTheme.agedGreen
        case .C: QuestTheme.agedGreen
        case .B: QuestTheme.gold
        case .A: QuestTheme.waxRedLight
        case .S: QuestTheme.waxRed
        }
    }

    var body: some View {
        Text(rank.rawValue)
            .font(.system(size: 14, weight: .bold, design: .serif))
            .foregroundStyle(color)
            .frame(width: 28, height: 28)
            .overlay(
                Circle().stroke(color, lineWidth: 2)
            )
    }
}
