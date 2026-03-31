import SwiftUI

struct MacSymptomFinderView: View {
    @State private var selected: Symptom?

    private let allZones = footZones + handZones
    private let allPoints = getAllPoints()

    var body: some View {
        HSplitView {
            List(symptoms, selection: Binding(
                get: { selected?.id },
                set: { id in selected = symptoms.first { $0.id == id } }
            )) { s in
                Label(s.name, systemImage: s.icon).tag(s.id)
            }
            .frame(minWidth: 200)

            if let s = selected {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(s.name).font(.title).fontWeight(.bold)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("SELF-CARE PROTOCOL").font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            Text(s.selfCare)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.quaternary)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("REFLEXOLOGY ZONES").font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            ForEach(s.reflexZones, id: \.self) { zId in
                                if let zone = allZones.first(where: { $0.id == zId }) {
                                    HStack(spacing: 10) {
                                        Circle().fill(zone.system.color).frame(width: 8, height: 8)
                                        VStack(alignment: .leading) {
                                            Text(zone.name).fontWeight(.medium)
                                            Text(zone.technique).font(.caption).foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("ACUPUNCTURE POINTS").font(.caption).fontWeight(.semibold).tracking(1.2).foregroundStyle(.secondary)
                            ForEach(s.acuPoints, id: \.self) { pId in
                                if let match = allPoints.first(where: { $0.point.id == pId }) {
                                    HStack(spacing: 10) {
                                        Text(match.point.id).font(.caption).fontWeight(.bold).foregroundStyle(match.color)
                                        VStack(alignment: .leading) {
                                            Text(match.point.name).fontWeight(.medium)
                                            Text(match.point.location).font(.caption).foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .frame(minWidth: 400)
            } else {
                Text("Select a symptom to see treatment options")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("What Hurts?")
    }
}
