import SwiftUI

struct BuildMenu: View {
    @Bindable var gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("BUILD")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.43))

            ForEach(Array(BuildingType.allCases.enumerated()), id: \.offset) { _, type in
                Button {
                    gameState.selectedBuildingType = type
                    gameState.inputMode = .build
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(type.displayName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                        HStack(spacing: 4) {
                            ForEach(Array(type.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue })), id: \.key) { resource, amount in
                                Text("\(resource.symbol)\(amount)")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: 44)
                    .background(
                        gameState.selectedBuildingType == type
                            ? Color(red: 0, green: 0.96, blue: 0.83).opacity(0.2)
                            : Color.white.opacity(0.05)
                    )
                    .overlay(
                        Rectangle()
                            .stroke(
                                gameState.selectedBuildingType == type
                                    ? Color(red: 0, green: 0.96, blue: 0.83).opacity(0.6)
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
                Text("DEMOLISH")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color(red: 0.97, green: 0.15, blue: 0.52))
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: 44)
                    .background(
                        gameState.inputMode == .demolish
                            ? Color(red: 0.97, green: 0.15, blue: 0.52).opacity(0.2)
                            : Color.white.opacity(0.05)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .frame(width: 200)
        .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.9))
        .overlay(
            Rectangle()
                .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
        )
    }
}
