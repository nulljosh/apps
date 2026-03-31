import SwiftUI

struct MacSessionHistoryView: View {
    @Environment(SessionStore.self) private var store

    var body: some View {
        Group {
            if store.sessions.isEmpty {
                ContentUnavailableView(
                    "No Sessions",
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    description: Text("Log your first session from the Reflexology or Points section.")
                )
            } else {
                Table(store.sessions) {
                    TableColumn("Type") { s in
                        Text(s.type.uppercased())
                            .font(.caption).fontWeight(.semibold).tracking(0.5)
                    }
                    .width(min: 80, ideal: 100)

                    TableColumn("Name") { s in Text(s.name) }
                        .width(min: 120, ideal: 180)

                    TableColumn("Area") { s in Text(s.area).foregroundStyle(.secondary) }
                        .width(min: 100, ideal: 140)

                    TableColumn("Date") { s in
                        Text(s.date, format: .dateTime.month(.abbreviated).day().hour().minute())
                            .foregroundStyle(.secondary)
                    }
                    .width(min: 140, ideal: 180)
                }
            }
        }
        .navigationTitle("Session History")
    }
}
