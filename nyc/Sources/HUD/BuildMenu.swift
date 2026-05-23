import SwiftUI

struct BuildMenu: View {
    @Bindable var gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("BUILD")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.04))

            ForEach(Array(BuildingType.allCases.enumerated()), id: \.offset) { idx, type in
                Button {
                    gameState.selectedBuildingType = type
                    gameState.inputMode = .build
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("\(idx + 1).")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(Color(red: 1.0, green: 0.22, blue: 0.37))
                            Text(type.displayName)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        HStack(spacing: 4) {
                            ForEach(Array(type.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue })), id: \.key) { resource, amount in
                                Text("\(resource.symbol)\(amount)")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        gameState.selectedBuildingType == type
                            ? Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.2)
                            : Color.white.opacity(0.05)
                    )
                    .overlay(
                        Rectangle()
                            .stroke(
                                gameState.selectedBuildingType == type
                                    ? Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.6)
                                    : Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }

            Divider().background(Color.white.opacity(0.2))

            Button {
                gameState.inputMode = .demolish
            } label: {
                Text("X. DEMOLISH")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.22, blue: 0.37))
                    .padding(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        gameState.inputMode == .demolish
                            ? Color(red: 1.0, green: 0.22, blue: 0.37).opacity(0.2)
                            : Color.white.opacity(0.05)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .frame(width: 180)
        .background(Color(red: 0.04, green: 0.04, blue: 0.05).opacity(0.9))
        .overlay(
            Rectangle()
                .stroke(Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.4), lineWidth: 2)
        )
    }
}
