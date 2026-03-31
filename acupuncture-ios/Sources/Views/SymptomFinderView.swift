import SwiftUI

struct SymptomFinderView: View {
    @State private var selected: Symptom?

    private let allZones = footZones + handZones
    private let allPoints = getAllPoints()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                        ForEach(symptoms) { s in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selected = selected?.id == s.id ? nil : s
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: s.icon)
                                        .font(.title3)
                                    Text(s.name)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(selected?.id == s.id
                                            ? Color(red: 0.141, green: 0.447, blue: 0.698).opacity(0.2)
                                            : Color(white: 0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selected?.id == s.id
                                                ? Color(red: 0.141, green: 0.447, blue: 0.698)
                                                : .clear, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)

                    if let s = selected {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(s.name).font(.title2).fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("SELF-CARE PROTOCOL")
                                    .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                                Text(s.selfCare)
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(white: 0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("REFLEXOLOGY ZONES")
                                    .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                                ForEach(s.reflexZones, id: \.self) { zId in
                                    if let zone = allZones.first(where: { $0.id == zId }) {
                                        HStack(spacing: 10) {
                                            Circle().fill(zone.system.color).frame(width: 8, height: 8)
                                            VStack(alignment: .leading) {
                                                Text(zone.name).font(.subheadline).fontWeight(.medium)
                                                Text(zone.location).font(.caption).foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("ACUPUNCTURE POINTS")
                                    .font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                                ForEach(s.acuPoints, id: \.self) { pId in
                                    if let match = allPoints.first(where: { $0.point.id == pId }) {
                                        HStack(spacing: 10) {
                                            Text(match.point.id)
                                                .font(.caption).fontWeight(.bold).foregroundStyle(match.color)
                                            VStack(alignment: .leading) {
                                                Text(match.point.name).font(.subheadline).fontWeight(.medium)
                                                Text(match.point.location).font(.caption).foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("What Hurts?")
        }
    }
}
