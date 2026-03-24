import SwiftUI

struct ColonistPanel: View {
    let gameState: GameState

    var body: some View {
        if let colonist = gameState.selectedColonist {
            VStack(alignment: .leading, spacing: 8) {
                // Name + state
                HStack {
                    Text(colonist.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.43))
                    Spacer()
                    Text("Lv.\(colonist.level)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(red: 0, green: 0.96, blue: 0.83))
                }

                Text(colonist.state.rawValue.uppercased())
                    .font(.system(size: 11))
                    .foregroundStyle(stateColor(colonist.state))

                // Trait badge
                HStack(spacing: 4) {
                    Text(colonist.trait.displayName.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(red: 0.97, green: 0.15, blue: 0.52))
                    Text(colonist.trait.description)
                        .font(.system(size: 9))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color(red: 0.97, green: 0.15, blue: 0.52).opacity(0.15))

                Divider().background(Color.white.opacity(0.2))

                // Health + needs bars
                needBar(label: "HP ", value: colonist.health, color: Color(red: 0.97, green: 0.15, blue: 0.15))
                needBar(label: "HNG", value: colonist.hunger, color: Color(red: 0.48, green: 0.95, blue: 0.47))
                needBar(label: "O2 ", value: colonist.oxygen, color: Color(red: 0, green: 0.96, blue: 0.83))
                needBar(label: "STS", value: 100 - colonist.stress, color: Color(red: 0.97, green: 0.15, blue: 0.52))
                needBar(label: "SLP", value: colonist.sleep, color: Color(red: 0.48, green: 0.47, blue: 0.95))

                Divider().background(Color.white.opacity(0.2))

                // RPG Stats
                Text("STATS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))

                statBar(label: "STR", value: colonist.stats.str)
                statBar(label: "INT", value: colonist.stats.int)
                statBar(label: "AGI", value: colonist.stats.agi)
                statBar(label: "END", value: colonist.stats.end)
                statBar(label: "CHA", value: colonist.stats.cha)

                // XP progress
                HStack(spacing: 6) {
                    Text("XP")
                        .font(.system(size: 10))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(width: 30, alignment: .leading)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)
                            Rectangle()
                                .fill(Color(red: 1.0, green: 0.9, blue: 0.43))
                                .frame(width: max(0, geo.size.width * colonist.xpProgress), height: 8)
                        }
                    }
                    .frame(height: 8)
                    Text("\(colonist.xp)/\(colonist.xpForNextLevel)")
                        .font(.system(size: 9))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(width: 50, alignment: .trailing)
                }

                Divider().background(Color.white.opacity(0.2))

                // Job assignment buttons
                Text("JOB: \(colonist.job.rawValue.uppercased())")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))

                HStack(spacing: 4) {
                    ForEach(ColonistJob.allCases, id: \.self) { job in
                        jobButton(job: job, isActive: colonist.job == job)
                    }
                }

                Divider().background(Color.white.opacity(0.2))

                // Weapon
                HStack(spacing: 4) {
                    Text("WEAPON:")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.6))
                    Text(colonist.weapon.displayName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.21))
                    Spacer()
                    Text("DMG: \(Int(colonist.weapon.damage))")
                        .font(.system(size: 9))
                        .foregroundStyle(.white.opacity(0.5))
                    Text("RNG: \(colonist.weapon.range)")
                        .font(.system(size: 9))
                        .foregroundStyle(.white.opacity(0.5))
                }

                Text("Pos: (\(colonist.col), \(colonist.row))")
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(10)
            .frame(width: 220)
            .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.9))
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
            )
        }
    }

    private func needBar(label: String, value: Double, color: Color) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 30, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)
                    Rectangle()
                        .fill(color)
                        .frame(width: max(0, geo.size.width * value / 100), height: 8)
                }
            }
            .frame(height: 8)
            Text("\(Int(value))")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 25, alignment: .trailing)
        }
    }

    private func statBar(label: String, value: Int) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 30, alignment: .leading)
            HStack(spacing: 2) {
                ForEach(0..<10, id: \.self) { i in
                    Rectangle()
                        .fill(i < value ? Color(red: 0, green: 0.96, blue: 0.83) : Color.white.opacity(0.1))
                        .frame(width: 12, height: 8)
                }
            }
            Text("\(value)")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 20, alignment: .trailing)
        }
    }

    private func jobButton(job: ColonistJob, isActive: Bool) -> some View {
        Button(action: {
            guard let id = gameState.selectedColonistId,
                  let idx = gameState.colonists.firstIndex(where: { $0.id == id }) else { return }
            gameState.colonists[idx].job = job
        }) {
            Text(job.rawValue.prefix(4).uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(isActive ? Color.black : Color.white.opacity(0.7))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isActive ? Color(red: 0, green: 0.96, blue: 0.83) : Color.white.opacity(0.1))
        }
        .buttonStyle(.plain)
    }

    private func stateColor(_ state: ColonistState) -> Color {
        switch state {
        case .healthy: Color(red: 0.48, green: 0.95, blue: 0.47)
        case .hungry: Color(red: 1.0, green: 0.9, blue: 0.43)
        case .suffocating: Color(red: 0, green: 0.96, blue: 0.83)
        case .exhausted: Color(red: 1.0, green: 0.42, blue: 0.21)
        case .dead: Color.gray
        }
    }
}
