import SwiftUI

struct ResourceBar: View {
    let gameState: GameState

    var body: some View {
        HStack(spacing: 16) {
            resourceItem(type: .food, color: Color(red: 0.19, green: 0.82, blue: 0.35))
            resourceItem(type: .power, color: Color(red: 1.0, green: 0.84, blue: 0.04))
            resourceItem(type: .materials, color: Color(red: 1.0, green: 0.62, blue: 0.04))
            resourceItem(type: .oxygen, color: Color(red: 0.39, green: 0.82, blue: 1.0))
            resourceItem(type: .cash, color: Color(red: 1.0, green: 0.22, blue: 0.37))

            Spacer()

            Text("\(gameState.colonists.filter { !$0.isDead }.count) alive")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(red: 0.04, green: 0.04, blue: 0.05).opacity(0.9))
        .overlay(
            Rectangle()
                .stroke(Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.4), lineWidth: 2)
        )
    }

    private func resourceItem(type: ResourceType, color: Color) -> some View {
        HStack(spacing: 4) {
            Text(type.symbol)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
            Text("\(gameState.resources[type, default: 0])")
                .font(.system(size: 13))
                .foregroundStyle(.white)
        }
    }
}
