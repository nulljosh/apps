import SwiftUI

struct EconomyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Wallet card
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Wallet")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Theme.textMuted)
                            Text("4,820")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(Theme.accent)
                    }

                    HStack(spacing: 10) {
                        Button {
                            // Send action placeholder
                        } label: {
                            Label("Send", systemImage: "arrow.up.circle.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)

                        Button {
                            // Request action placeholder
                        } label: {
                            Label("Request", systemImage: "arrow.down.circle.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Theme.card)
                                .foregroundStyle(Theme.textSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Activity feed
                VStack(alignment: .leading, spacing: 10) {
                    Text("Activity")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)

                    ForEach(sampleActivities) { activity in
                        HStack(spacing: 10) {
                            Image(systemName: activity.icon)
                                .font(.system(size: 14))
                                .frame(width: 28, height: 28)
                                .background(activity.positive ? Theme.green.opacity(0.15) : Theme.accent.opacity(0.15))
                                .foregroundStyle(activity.positive ? Theme.green : Theme.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 6))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(activity.label)
                                    .font(.system(size: 13, weight: .medium))
                                Text(activity.timestamp)
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.textMuted)
                            }

                            Spacer()

                            Text(activity.amount)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(activity.positive ? Theme.green : Theme.accent)
                        }
                        .padding(.vertical, 4)

                        if activity.id != sampleActivities.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Leaderboard
                VStack(alignment: .leading, spacing: 10) {
                    Text("Leaderboard")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)

                    ForEach(sampleLeaders) { leader in
                        HStack(spacing: 10) {
                            Text("#\(leader.rank)")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(leaderColor(rank: leader.rank))
                                .frame(width: 30, alignment: .leading)

                            Circle()
                                .fill(Theme.violet.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(String(leader.name.prefix(1)).uppercased())
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Theme.violet)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(leader.name)
                                        .font(.system(size: 13, weight: .semibold))
                                    if leader.verified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 10))
                                            .foregroundStyle(Theme.accent)
                                    }
                                }
                                Text("\(leader.clout.formatted()) clout")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.textMuted)
                            }

                            Spacer()
                        }
                        .padding(.vertical, 4)

                        if leader.id != sampleLeaders.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(20)
        }
        .background(Theme.bg)
        .navigationTitle("Economy")
    }

    private func leaderColor(rank: Int) -> Color {
        switch rank {
        case 1: return Theme.amber
        case 2: return Theme.textSecondary
        case 3: return Color(hex: "#cd7f32")
        default: return Theme.textMuted
        }
    }
}

#Preview {
    EconomyView()
}
