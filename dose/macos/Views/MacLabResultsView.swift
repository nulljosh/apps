import SwiftUI
import Charts

struct MacLabResultsView: View {
    @Bindable var dataStore: DataStore
    @State private var showAdd = false
    @State private var selectedMarker = ""
    @State private var tab = "timeline"

    private var sorted: [LabResult] { dataStore.labResults.sorted { $0.date > $1.date } }
    private var markerNames: [String] { dataStore.allMarkerNames }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $tab) {
                Text("Timeline").tag("timeline")
                Text("Markers").tag("markers")
            }
            .pickerStyle(.segmented)
            .padding()

            if tab == "timeline" {
                if sorted.isEmpty {
                    ContentUnavailableView("No Lab Results", systemImage: "cross.vial",
                        description: Text("Add results using the button above, or import from a LifeLabs PDF on the web app."))
                } else {
                    List(sorted) { result in
                        DisclosureGroup {
                            ForEach(result.markers) { m in
                                HStack {
                                    Text(m.name).frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(m.value, specifier: "%.1f") \(m.unit)")
                                        .fontWeight(.semibold)
                                    FlagLabel(flag: m.flag)
                                }
                                .padding(.vertical, 2)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(result.date, style: .date).font(.caption).foregroundStyle(.secondary)
                                    Text("\(result.lab) — \(result.panel)").fontWeight(.medium)
                                }
                                Spacer()
                                if result.flaggedCount > 0 {
                                    Text("\(result.flaggedCount) flagged")
                                        .font(.caption2).fontWeight(.bold)
                                        .foregroundStyle(.red)
                                        .padding(.horizontal, 7).padding(.vertical, 3)
                                        .background(Color.red.opacity(0.1)).clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Picker("Marker", selection: $selectedMarker) {
                        ForEach(markerNames, id: \.self) { Text($0).tag($0) }
                    }
                    .padding(.horizontal)

                    let history = dataStore.labResultsByMarker(selectedMarker)
                    if history.count >= 2 {
                        Chart {
                            ForEach(history, id: \.date) { row in
                                LineMark(x: .value("Date", row.date), y: .value("Value", row.marker.value))
                                    .foregroundStyle(.blue)
                                PointMark(x: .value("Date", row.date), y: .value("Value", row.marker.value))
                                    .foregroundStyle(row.marker.flag == .normal ? Color.blue : .orange)
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    } else {
                        Text("Need at least 2 readings.").foregroundStyle(.secondary).padding()
                    }
                    Spacer()
                }
                .onAppear { if selectedMarker.isEmpty { selectedMarker = markerNames.first ?? "" } }
            }
        }
        .navigationTitle("Lab Results")
        .toolbar {
            ToolbarItem { Button("Add Result") { showAdd = true } }
        }
        .sheet(isPresented: $showAdd) {
            AddLabResultSheet(dataStore: dataStore)
                .frame(minWidth: 480, minHeight: 500)
        }
    }
}
