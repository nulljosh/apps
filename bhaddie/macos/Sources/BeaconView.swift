import SwiftUI

struct BeaconView: View {
    @State private var broadcasting = false
    @State private var shareMode: ShareMode = .fuzzy

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Broadcast toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Broadcast")
                            .font(.system(size: 20, weight: .bold))
                        Text(broadcasting ? "Your beacon is live" : "Your beacon is off")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Spacer()
                    Toggle("", isOn: $broadcasting)
                        .toggleStyle(.switch)
                        .tint(Theme.accent)
                        .labelsHidden()
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Share mode picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Share Mode")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)

                    ForEach(ShareMode.allCases) { mode in
                        Button {
                            shareMode = mode
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: mode.icon)
                                    .font(.system(size: 14))
                                    .frame(width: 28, height: 28)
                                    .background(shareMode == mode ? Theme.accent.opacity(0.15) : Theme.border.opacity(0.5))
                                    .foregroundStyle(shareMode == mode ? Theme.accent : Theme.textSecondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(mode.rawValue)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.primary)
                                    Text(mode.description)
                                        .font(.system(size: 11))
                                        .foregroundStyle(Theme.textMuted)
                                }

                                Spacer()

                                if shareMode == mode {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Theme.accent)
                                        .font(.system(size: 16))
                                }
                            }
                            .padding(10)
                            .background(shareMode == mode ? Theme.accent.opacity(0.05) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(shareMode == mode ? Theme.accent.opacity(0.3) : Theme.border, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Stats row
                HStack(spacing: 12) {
                    BeaconStatCard(value: "1.2k", label: "Followers", color: Theme.accent)
                    BeaconStatCard(value: "847", label: "Views today", color: Theme.violet)
                    BeaconStatCard(value: "24", label: "Tips today", color: Theme.green)
                }

                // Followers list
                VStack(alignment: .leading, spacing: 10) {
                    Text("Followers")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)

                    ForEach(sampleFollowers) { follower in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Theme.violet.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(String(follower.name.prefix(1)).uppercased())
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(Theme.violet)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(follower.name)
                                        .font(.system(size: 13, weight: .semibold))
                                    if follower.verified {
                                        Image(systemName: "checkmark.seal.fill")
                                            .font(.system(size: 10))
                                            .foregroundStyle(Theme.accent)
                                    }
                                }
                                Text("\(follower.clout.formatted()) clout")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.textMuted)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        if follower.id != sampleFollowers.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(16)
                .background(Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Hours grid
                VStack(alignment: .leading, spacing: 10) {
                    Text("Active Hours")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 12), spacing: 4) {
                        ForEach(0..<24, id: \.self) { hour in
                            let intensity = hoursData[hour]
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Theme.accent.opacity(intensity))
                                .frame(height: 24)
                                .overlay(
                                    Text("\(hour)")
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundStyle(intensity > 0.3 ? .white : Theme.textMuted)
                                )
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
        .navigationTitle("Beacon")
    }

    private var hoursData: [Double] {
        [0.05, 0.02, 0.01, 0.01, 0.02, 0.05,
         0.1, 0.2, 0.35, 0.5, 0.45, 0.55,
         0.6, 0.5, 0.45, 0.5, 0.6, 0.7,
         0.8, 0.9, 1.0, 0.85, 0.5, 0.2]
    }
}

struct BeaconStatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    BeaconView()
}
