import SwiftUI
import MapKit

struct RadarView: View {
    @State private var selectedVibe = "all"
    @State private var selectedScene: Scene?
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    private var filteredScenes: [Scene] {
        if selectedVibe == "all" {
            return SampleData.scenes
        }
        return SampleData.scenes.filter { $0.vibes.contains(selectedVibe) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition) {
                ForEach(filteredScenes) { scene in
                    Annotation(scene.name, coordinate: scene.coordinate) {
                        BlipMarker(scene: scene, isSelected: selectedScene?.id == scene.id)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                                    selectedScene = scene
                                }
                            }
                    }
                }
            }
            .mapStyle(.standard(pointsOfInterest: .excludingAll))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    ForEach(SampleData.vibes, id: \.self) { vibe in
                        VibeChip(title: vibe, isSelected: selectedVibe == vibe) {
                            selectedVibe = vibe
                        }
                    }
                }
                .padding(.horizontal, 14)
            }
            .padding(.top, 10)
        }
        .sheet(item: $selectedScene) { scene in
            ProfileCardSheet(scene: scene)
                .presentationDetents([.height(340)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(22)
        }
    }
}

// MARK: - Blip Marker

struct BlipMarker: View {
    let scene: Scene
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(scene.color)
            .frame(width: isSelected ? 20 : 14, height: isSelected ? 20 : 14)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.white : Color.white.opacity(0.25), lineWidth: 2)
            )
            .overlay(
                Circle()
                    .fill(scene.color.opacity(0.3))
                    .frame(width: 30, height: 30)
            )
            .scaleEffect(isSelected ? 1.3 : 1.0)
            .animation(.spring(duration: 0.2, bounce: 0.5), value: isSelected)
    }
}

// MARK: - Vibe Chip

struct VibeChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12.5, weight: .semibold))
                .padding(.horizontal, 15)
                .padding(.vertical, 7)
                .background(isSelected ? Theme.accent : Color(.secondarySystemBackground).opacity(0.9))
                .foregroundStyle(isSelected ? .white : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color(.separator), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Profile Card Sheet

struct ProfileCardSheet: View {
    let scene: Scene

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 13) {
                Circle()
                    .fill(scene.color)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(scene.name.prefix(2)).uppercased())
                            .font(.system(size: 17, weight: .heavy))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 5) {
                        Text(scene.name)
                            .font(.system(size: 16, weight: .bold))
                        if scene.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.cyan)
                        }
                    }
                    HStack(spacing: 3) {
                        Text("Clout:")
                            .foregroundStyle(.secondary)
                        Text(formatClout(scene.clout))
                            .foregroundStyle(Theme.violet)
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 12.5))
                }

                Spacer()
            }

            HStack(spacing: 5) {
                ForEach(scene.vibes, id: \.self) { vibe in
                    Text(vibe)
                        .font(.system(size: 10.5, weight: .semibold))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .overlay(
                            Capsule()
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 5) {
                HStack {
                    Text("Streak")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(scene.streak)/\(scene.maxStreak)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(.separator).opacity(0.3))
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.accent)
                            .frame(width: geo.size.width * (Double(scene.streak) / Double(scene.maxStreak)))
                    }
                }
                .frame(height: 5)
            }

            HStack(spacing: 8) {
                Button {
                    // upvote action
                } label: {
                    Text("Upvote")
                        .font(.system(size: 13.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    // close
                } label: {
                    Text("Close")
                        .font(.system(size: 13.5, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        .foregroundStyle(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
    }

    private func formatClout(_ value: Int) -> String {
        if value >= 1000 {
            let k = Double(value) / 1000.0
            return String(format: "%.1fk", k)
        }
        return "\(value)"
    }
}

extension Scene: Hashable {
    static func == (lhs: Scene, rhs: Scene) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

#Preview {
    RadarView()
}
