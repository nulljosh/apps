import SwiftUI

struct DashboardView: View {
    @Bindable var dataStore: DataStore
    @Bindable var notificationService: NotificationService
    var syncService: SyncService
    @State private var showAddDose = false
    @State private var showReminders = false
    @State private var showSettings = false

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        if (5...11).contains(hour) {
            timeGreeting = "Good morning"
        } else if (12...16).contains(hour) {
            timeGreeting = "Good afternoon"
        } else {
            timeGreeting = "Good evening"
        }
        let name = dataStore.userName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? timeGreeting : "\(timeGreeting), \(name)"
    }

    private var activePills: [ActivePill] {
        let grouped = Dictionary(grouping: dataStore.getActive()) { dataStore.substanceName(for: $0) }

        return grouped.compactMap { name, entries in
            let first = entries.first
            let builtIn = first.flatMap { SubstanceDatabase.find(id: $0.substanceKey) }
            let color = builtIn?.category.categoryColor ?? Color.secondary
            let latest = entries.map(\.timestamp).max() ?? .distantPast
            return ActivePill(name: name, color: color, count: entries.count, latestTimestamp: latest)
        }
        .sorted { $0.latestTimestamp > $1.latestTimestamp }
    }

    private var recentEntries: [DoseEntry] {
        Array(dataStore.doseEntries.sorted { $0.timestamp > $1.timestamp }.prefix(5))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if dataStore.streakCount > 0 {
                        HStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                            Text("\(dataStore.streakCount) day streak")
                                .glowText()
                        }
                        .font(.headline)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .glassCard()
                        .shadow(color: .orange.opacity(0.22), radius: 10, x: 0, y: 0)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Active stack")
                                .font(.headline)

                            Spacer()

                            Button("Quick log") {
                                showAddDose = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.85))
                        }

                        if activePills.isEmpty {
                            ContentUnavailableView("No Active Substances", systemImage: "pill", description: Text("Nothing taken in the last 24 hours"))
                                .frame(maxHeight: 120)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(activePills) { pill in
                                        Text(pill.count > 1 ? "\(pill.name) x\(pill.count)" : pill.name)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(pill.color)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(16)
                    .glassCard()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent entries")
                            .font(.headline)

                        if recentEntries.isEmpty {
                            ContentUnavailableView("No Doses Yet", systemImage: "pills.fill", description: Text("Tap Quick log to log your first dose"))
                                .frame(maxHeight: 120)
                        } else {
                            ForEach(recentEntries) { entry in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dataStore.substanceName(for: entry))
                                        .font(.body.weight(.semibold))

                                    if let dose = entry.dose {
                                        let unit = (entry.unit ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                                        Text(unit.isEmpty ? "\(dose.formatted())" : "\(dose.formatted()) \(unit)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }

                                    Text(entry.timestamp, style: .relative)
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .glassCard()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(greeting)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showReminders = true
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
            .sheet(isPresented: $showAddDose) {
                AddDoseSheet(dataStore: dataStore)
            }
            .sheet(isPresented: $showReminders) {
                RemindersView(notificationService: notificationService)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(dataStore: dataStore, syncService: syncService)
            }
        }
    }
}

private struct ActivePill: Identifiable {
    var id: String { name }
    let name: String
    let color: Color
    let count: Int
    let latestTimestamp: Date
}
