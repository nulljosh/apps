import SwiftUI

struct MacMeridianListView: View {
    @State private var selectedMeridian: Meridian?
    @State private var selectedPoint: AcuPoint?
    @Environment(SessionStore.self) private var store

    var body: some View {
        HSplitView {
            List(meridians, selection: Binding(
                get: { selectedMeridian?.id },
                set: { id in selectedMeridian = meridians.first { $0.id == id }; selectedPoint = nil }
            )) { m in
                HStack(spacing: 10) {
                    Circle().fill(m.color).frame(width: 8, height: 8)
                    Text(m.name)
                    Spacer()
                    Text(m.abbr).font(.caption).fontWeight(.bold).foregroundStyle(m.color)
                    Text("\(m.points.count)").font(.caption).foregroundStyle(.secondary)
                }
                .tag(m.id)
            }
            .frame(minWidth: 220)

            if let m = selectedMeridian {
                List(m.points, selection: Binding(
                    get: { selectedPoint?.id },
                    set: { id in selectedPoint = m.points.first { $0.id == id } }
                )) { p in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(p.id).fontWeight(.bold).foregroundStyle(m.color)
                            Text(p.name).fontWeight(.medium)
                        }
                        Text(p.english).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                    .tag(p.id)
                }
                .frame(minWidth: 200)

                if let p = selectedPoint {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text(p.id).font(.title2).fontWeight(.bold).foregroundStyle(m.color)
                                Text(p.name).font(.title2).fontWeight(.bold)
                            }
                            Text(p.english).foregroundStyle(.secondary)

                            Divider()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("LOCATION").font(.caption).fontWeight(.semibold).tracking(1).foregroundStyle(.secondary)
                                Text(p.location)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TECHNIQUE").font(.caption).fontWeight(.semibold).tracking(1).foregroundStyle(.secondary)
                                Text(p.technique)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("INDICATIONS").font(.caption).fontWeight(.semibold).tracking(1).foregroundStyle(.secondary)
                                FlowLayout(spacing: 4) {
                                    ForEach(p.indications, id: \.self) { ind in
                                        Text(ind).font(.caption)
                                            .padding(.horizontal, 8).padding(.vertical, 4)
                                            .background(m.color.opacity(0.12))
                                            .clipShape(Capsule())
                                    }
                                }
                            }

                            Button("Log Session") {
                                store.add(Session(type: "acupuncture", name: "\(p.id) \(p.name)", area: m.name))
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    .frame(minWidth: 280)
                } else {
                    Text("Select a point")
                        .foregroundStyle(.secondary)
                        .frame(minWidth: 280)
                }
            } else {
                Text("Select a meridian")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Acupuncture Points")
    }
}
