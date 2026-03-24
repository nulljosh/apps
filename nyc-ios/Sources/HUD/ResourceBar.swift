import SwiftUI

struct ResourceBar: View {
    let gameState: GameState

    var body: some View {
        HStack(spacing: 16) {
            resourceItem(type: .food, color: Color(red: 0.48, green: 0.95, blue: 0.47))
            resourceItem(type: .power, color: Color(red: 1.0, green: 0.9, blue: 0.43))
            resourceItem(type: .materials, color: Color(red: 1.0, green: 0.42, blue: 0.21))
            resourceItem(type: .oxygen, color: Color(red: 0, green: 0.96, blue: 0.83))
            resourceItem(type: .cash, color: Color(red: 0.97, green: 0.15, blue: 0.52))

            Spacer()

            Text("\(gameState.colonists.filter { !$0.isDead }.count) alive")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.9))
        .overlay(
            Rectangle()
                .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
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
