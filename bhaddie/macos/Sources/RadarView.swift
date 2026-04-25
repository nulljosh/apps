import SwiftUI
import MapKit

struct RadarView: View {
    @State private var selectedBaddie: Baddie?
    @State private var activeVibe: String = "all"
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207),
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    )

    private let allVibes = ["all", "alt", "artsy", "gym", "downtown", "night-owl"]

    private var filteredBaddies: [Baddie] {
        if activeVibe == "all" {
            return sampleBaddies
        }
        return sampleBaddies.filter { $0.vibes.contains(activeVibe) }
    }

    var body: some View {
        HSplitView {
            VStack(spacing: 0) {
                // Vibe filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(allVibes, id: \.self) { vibe in
                            Button {
                                activeVibe = vibe
                            } label: {
                                Text(vibe)
                                    .font(.system(size: 11, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(activeVibe == vibe ? Theme.accent : Theme.card)
                                    .foregroundStyle(activeVibe == vibe ? .white : Theme.textSecondary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .background(Theme.bg)

                // Map
                Map(position: $position, selection: $selectedBaddie) {
                    ForEach(filteredBaddies) { baddie in
                        Annotation(baddie.name, coordinate: baddie.coordinate, anchor: .bottom) {
                            BaddieMarker(baddie: baddie, isSelected: selectedBaddie?.id == baddie.id)
                                .onTapGesture {
                                    selectedBaddie = baddie
                                }
                        }
                        .tag(baddie)
                    }
                }
                .mapStyle(.standard(pointsOfInterest: .excludingAll))
            }

            // Detail sidebar
            if let baddie = selectedBaddie {
                BaddieDetailPanel(baddie: baddie) {
                    selectedBaddie = nil
                }
                .frame(width: 260)
            }
        }
        .navigationTitle("Radar")
    }
}

// MARK: - Baddie Map Marker

struct BaddieMarker: View {
    let baddie: Baddie
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(Color(hex: baddie.color))
                    .frame(width: isSelected ? 32 : 24, height: isSelected ? 32 : 24)
                if baddie.verified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.white)
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)

            if isSelected {
                Text(baddie.name)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Detail Panel

struct BaddieDetailPanel: View {
    let baddie: Baddie
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                Button { onClose() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.textMuted)
                }
                .buttonStyle(.plain)
            }

            // Name and verified badge
            HStack(spacing: 6) {
                Text(baddie.name)
                    .font(.system(size: 18, weight: .bold))
                if baddie.verified {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Theme.accent)
                        .font(.system(size: 14))
                }
            }

            // Vibes
            HStack(spacing: 4) {
                ForEach(baddie.vibes, id: \.self) { vibe in
                    Text(vibe)
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.violet.opacity(0.15))
                        .foregroundStyle(Theme.violet)
                        .clipShape(Capsule())
                }
            }

            // Stats
            VStack(spacing: 10) {
                StatRow(label: "Clout", value: baddie.clout.formatted(), color: Theme.violet)
                StatRow(label: "Streak", value: "\(baddie.streak) days", color: Theme.amber)

                // Streak progress
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.border)
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.accent)
                            .frame(width: geo.size.width * Double(baddie.streak) / Double(baddie.maxStreak), height: 5)
                    }
                }
                .frame(height: 5)

                HStack {
                    Text("\(baddie.streak)/\(baddie.maxStreak)")
                        .font(.system(size: 10))
                        .foregroundStyle(Theme.textMuted)
                    Spacer()
                }
            }
            .padding(12)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Action buttons
            HStack(spacing: 8) {
                Button {
                    // DM action placeholder
                } label: {
                    Label("DM", systemImage: "paperplane.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)

                Button {
                    // Block action placeholder
                } label: {
                    Label("Block", systemImage: "hand.raised.fill")
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

            Spacer()
        }
        .padding(16)
        .background(Theme.bg)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(color)
        }
    }
}

extension Baddie: Hashable {
    static func == (lhs: Baddie, rhs: Baddie) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    RadarView()
}
