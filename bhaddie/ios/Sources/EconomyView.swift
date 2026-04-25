import SwiftUI

struct EconomyView: View {
    @State private var tokenBalance = 2847

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // Wallet card
                    VStack(spacing: 10) {
                        Text("WALLET")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        Text(formattedBalance)
                            .font(.system(size: 48, weight: .heavy))
                            .tracking(-1.5)
                            .foregroundStyle(Theme.accent)

                        Text("1 token = $0.01 USD")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            Button {
                                // Cash out action
                            } label: {
                                Text("Cash Out")
                                    .font(.system(size: 13.5, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 11)
                                    .background(Theme.accent)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            Button {
                                // Buy tokens action
                            } label: {
                                Text("Buy Tokens")
                                    .font(.system(size: 13.5, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 11)
                                    .background(Color(.secondarySystemBackground))
                                    .foregroundStyle(.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(.separator), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(18)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    // Activity feed
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ACTIVITY")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 0) {
                            ForEach(SampleData.activityFeed) { item in
                                ActivityRow(item: item)
                            }
                        }
                    }

                    // Leaderboard
                    VStack(alignment: .leading, spacing: 10) {
                        Text("LEADERBOARD")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 6) {
                            ForEach(SampleData.leaders) { leader in
                                LeaderRow(leader: leader)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Economy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: tokenBalance)) ?? "\(tokenBalance)"
    }
}

// MARK: - Activity Row

struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: item.icon)
                .font(.system(size: 14))
                .foregroundStyle(Theme.accent)
                .frame(width: 34, height: 34)
                .background(item.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 9))

            Text(item.text)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)

            Spacer()

            Text(item.time)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 9)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - Leader Row

struct LeaderRow: View {
    let leader: Leader

    var body: some View {
        HStack(spacing: 11) {
            Text("\(leader.rank)")
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(rankColor)
                .frame(width: 24, alignment: .center)

            Circle()
                .fill(leader.color)
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(leader.name.prefix(2)).uppercased())
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 4) {
                    Text(leader.name)
                        .font(.system(size: 14, weight: .bold))
                    if leader.verified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.cyan)
                    }
                }
                Text("\(formatClout(leader.clout)) clout")
                    .font(.system(size: 11.5))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if leader.rank == 1 {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.amber)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var rankColor: Color {
        switch leader.rank {
        case 1: return Theme.amber
        case 2: return Color(.systemGray)
        case 3: return Color(hex: "#cd7f32")
        default: return .secondary
        }
    }

    private func formatClout(_ value: Int) -> String {
        if value >= 1000 {
            let k = Double(value) / 1000.0
            return String(format: "%.1fk", k)
        }
        return "\(value)"
    }
}

#Preview {
    EconomyView()
}
