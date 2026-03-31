import SwiftUI

struct MacSymptomFinderView: View {
    @State private var query = ""
    @State private var selected: Symptom?

    private let allZones = footZones + handZones
    private let allPoints = getAllPoints()

    private var filtered: [Symptom] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return symptoms }
        return symptoms.filter {
            $0.name.lowercased().contains(q) ||
            $0.selfCare.lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("What hurts? Type a symptom...", text: $query)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .onSubmit {
                        if let first = filtered.first { selected = first }
                    }
                if !query.isEmpty {
                    Button { query = ""; selected = nil } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.bar)

            Divider()

            if let s = selected ?? (filtered.count == 1 ? filtered.first : nil) {
                // Result view
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button { selected = nil } label: {
                                Label("Back to results", systemImage: "chevron.left")
                                    .font(.caption)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                            Spacer()
                        }

                        Text(s.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        // TLDR self-care
                        VStack(alignment: .leading, spacing: 8) {
                            Label("WHAT TO DO", systemImage: "hand.point.up.left")
                                .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            Text(s.selfCare)
                                .font(.body)
                                .lineSpacing(4)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }

                        // Reflexology zones
                        VStack(alignment: .leading, spacing: 10) {
                            Label("PRESSURE ZONES", systemImage: "figure.walk")
                                .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            ForEach(s.reflexZones, id: \.self) { zId in
                                if let zone = allZones.first(where: { $0.id == zId }) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Circle().fill(zone.system.color).frame(width: 10, height: 10).padding(.top, 4)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(zone.name).fontWeight(.semibold)
                                            Text(zone.location).font(.caption).foregroundStyle(.secondary)
                                            Text(zone.technique).font(.caption2).foregroundStyle(.tertiary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }

                        // Acupuncture points
                        VStack(alignment: .leading, spacing: 10) {
                            Label("ACUPUNCTURE POINTS", systemImage: "target")
                                .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            ForEach(s.acuPoints, id: \.self) { pId in
                                if let match = allPoints.first(where: { $0.point.id == pId }) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Text(match.point.id)
                                            .font(.caption).fontWeight(.bold)
                                            .foregroundStyle(match.color)
                                            .frame(width: 36, alignment: .leading)
                                            .padding(.top, 2)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("\(match.point.name) (\(match.point.english))")
                                                .fontWeight(.semibold)
                                            Text(match.point.location).font(.caption).foregroundStyle(.secondary)
                                            Text(match.point.technique).font(.caption2).foregroundStyle(.tertiary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .padding(24)
                }
            } else {
                // Symptom grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                        ForEach(filtered) { s in
                            Button {
                                selected = s
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: s.icon)
                                        .font(.title2)
                                        .foregroundStyle(.primary)
                                    Text(s.name)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(24)

                    if filtered.isEmpty {
                        ContentUnavailableView("No matches", systemImage: "magnifyingglass", description: Text("Try a different term"))
                            .padding(.top, 40)
                    }
                }
            }
        }
        .navigationTitle("What Hurts?")
        .onChange(of: query) { selected = nil }
    }
}
