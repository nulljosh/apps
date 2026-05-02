import SwiftUI

struct ColonistPanel: View {
    let gameState: GameState

    var body: some View {
        if let colonist = gameState.selectedColonist {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(colonist.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.yellow)
                    Spacer()
                    Text("Lv.\(colonist.level)")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.cyan)
                }

                Text(colonist.state.rawValue.uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(stateColor(colonist.state))

                HStack(spacing: 4) {
                    Text(colonist.trait.displayName.uppercased())
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.pink)
                    Text(colonist.trait.description)
                        .font(.system(size: 9))
                        .foregroundStyle(Theme.text3)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Capsule().fill(Theme.pink.opacity(0.12)))

                Divider().background(Theme.border)

                vitalBar(label: "HP",  value: colonist.health)
                vitalBar(label: "HNG", value: colonist.hunger)
                vitalBar(label: "O2",  value: colonist.oxygen)
                vitalBar(label: "STS", value: 100 - colonist.stress)
                vitalBar(label: "SLP", value: colonist.sleep)

                Divider().background(Theme.border)

                Text("STATS")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.text2)

                statDots(label: "STR", value: colonist.stats.str)
                statDots(label: "INT", value: colonist.stats.int)
                statDots(label: "AGI", value: colonist.stats.agi)
                statDots(label: "END", value: colonist.stats.end)
                statDots(label: "CHA", value: colonist.stats.cha)

                HStack(spacing: 6) {
                    Text("XP")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(Theme.text2)
                        .frame(width: 28, alignment: .leading)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2).fill(Theme.glass).frame(height: 4)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.yellow)
                                .frame(width: max(0, geo.size.width * colonist.xpProgress), height: 4)
                        }
                    }
                    .frame(height: 4)
                    Text("\(colonist.xp)/\(colonist.xpForNextLevel)")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(Theme.text3)
                        .frame(width: 50, alignment: .trailing)
                }

                Divider().background(Theme.border)

                Text("JOB: \(colonist.job.rawValue.uppercased())")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.text2)

                HStack(spacing: 4) {
                    ForEach(ColonistJob.allCases, id: \.self) { job in
                        jobPill(job: job, isActive: colonist.job == job)
                    }
                }

                Divider().background(Theme.border)

                HStack(spacing: 4) {
                    Text("WEAPON:")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.text2)
                    Text(colonist.weapon.displayName)
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Theme.orange)
                    Spacer()
                    Text("DMG:\(Int(colonist.weapon.damage)) RNG:\(colonist.weapon.range)")
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(Theme.text3)
                }

                Text("(\(colonist.col), \(colonist.row))")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(Theme.text3)
            }
            .padding(10)
            .frame(width: 220)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: Theme.radiusLg))
            .overlay(RoundedRectangle(cornerRadius: Theme.radiusLg).stroke(Theme.border, lineWidth: 1))
        }
    }

    private func vitalBar(label: String, value: Double) -> some View {
        let v = max(0, min(100, value))
        return HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(Theme.text2)
                .frame(width: 28, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(Theme.glass).frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.vitalColor(v))
                        .frame(width: max(0, geo.size.width * v / 100), height: 4)
                }
            }
            .frame(height: 4)
            Text("\(Int(value))")
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(Theme.text3)
                .frame(width: 22, alignment: .trailing)
        }
    }

    private func statDots(label: String, value: Int) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(Theme.text2)
                .frame(width: 28, alignment: .leading)
            HStack(spacing: 2) {
                ForEach(0..<10, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(i < value ? Theme.accent.opacity(0.9) : Theme.glass)
                        .frame(width: 10, height: 4)
                }
            }
            Text("\(value)")
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(Theme.text3)
                .frame(width: 18, alignment: .trailing)
        }
    }

    private func jobPill(job: ColonistJob, isActive: Bool) -> some View {
        Button(action: {
            guard let id = gameState.selectedColonistId,
                  let idx = gameState.colonists.firstIndex(where: { $0.id == id }) else { return }
            gameState.colonists[idx].job = job
        }) {
            Text(job.rawValue.prefix(4).uppercased())
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundStyle(isActive ? .white : Theme.text2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(isActive ? Theme.accent.opacity(0.35) : Theme.glass)
                        .overlay(Capsule().stroke(isActive ? Theme.accent : Theme.border, lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
    }

    private func stateColor(_ state: ColonistState) -> Color {
        switch state {
        case .healthy: Theme.green
        case .hungry: Theme.yellow
        case .suffocating: Theme.cyan
        case .exhausted: Theme.orange
        case .dead: .gray
        }
    }
}
