import SwiftUI

struct BeaconView: View {
    @State private var isBroadcasting = false
    @State private var shareMode: ShareMode = .fuzzy
    @State private var activeHours: Set<Int> = [6, 7, 8, 9]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // Broadcast toggle card
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Broadcast")
                                .font(.system(size: 15, weight: .bold))
                            Text(isBroadcasting ? "You're visible on radar" : "You're hidden")
                                .font(.system(size: 11.5))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $isBroadcasting)
                            .toggleStyle(SwitchToggleStyle(tint: Theme.accent))
                            .labelsHidden()
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Share mode picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SHARE MODE")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(ShareMode.allCases, id: \.self) { mode in
                                ShareModeCard(mode: mode, isSelected: shareMode == mode) {
                                    withAnimation(.spring(duration: 0.2, bounce: 0.4)) {
                                        shareMode = mode
                                    }
                                }
                            }
                        }
                    }

                    // Stats row
                    HStack(spacing: 8) {
                        StatCard(value: "+12", label: "today", color: Theme.green)
                        StatCard(value: "18%", label: "this week", color: Theme.violet)
                        StatCard(value: "1.2k", label: "followers", color: Theme.cyan)
                    }

                    // Active followers
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ACTIVE FOLLOWERS")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 0) {
                            ForEach(SampleData.followers) { follower in
                                FollowerRow(follower: follower)
                            }
                        }
                    }

                    // Baddie Hours grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BADDIE HOURS")
                            .font(.system(size: 10.5, weight: .bold))
                            .tracking(1)
                            .foregroundStyle(.secondary)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 4), spacing: 6) {
                            ForEach(Array(SampleData.hours.enumerated()), id: \.offset) { index, hour in
                                HourSlot(hour: hour, isActive: activeHours.contains(index)) {
                                    if activeHours.contains(index) {
                                        activeHours.remove(index)
                                    } else {
                                        activeHours.insert(index)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Beacon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Share Mode Card

struct ShareModeCard: View {
    let mode: ShareMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: mode.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.accent : .secondary)
                Text(mode.rawValue)
                    .font(.system(size: 12.5, weight: .bold))
                Text(mode.description)
                    .font(.system(size: 10.5))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Theme.accent : Color(.separator), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 20, weight: .heavy))
                .tracking(-0.5)
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 10.5))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Follower Row

struct FollowerRow: View {
    let follower: Follower

    var body: some View {
        HStack(spacing: 11) {
            Circle()
                .fill(follower.color)
                .frame(width: 34, height: 34)
                .overlay(
                    Text(String(follower.name.prefix(2)).uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 1) {
                Text(follower.name)
                    .font(.system(size: 13.5, weight: .semibold))
                Text(follower.watching ? "Watching now" : "Last seen 2h ago")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if follower.watching {
                Circle()
                    .fill(Theme.green)
                    .frame(width: 7, height: 7)
            }
        }
        .padding(.vertical, 9)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

// MARK: - Hour Slot

struct HourSlot: View {
    let hour: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(hour)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(isActive ? Theme.accent : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(isActive ? Theme.accent.opacity(0.12) : Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isActive ? Theme.accent : Color(.separator), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BeaconView()
}
