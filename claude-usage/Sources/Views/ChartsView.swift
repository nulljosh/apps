import SwiftUI
import Charts

struct ChartsView: View {
    @Environment(UsageStore.self) private var store

    private var monthlyData: [(month: String, provider: String, cost: Double)] {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM"
        var result: [(String, String, Double)] = []
        for entry in store.filteredEntries {
            let label = fmt.string(from: entry.date)
            result.append((label, entry.provider.displayName, entry.costEstimate))
        }
        return result
    }

    private var conversationsByDay: [(date: Date, count: Int)] {
        store.last30DaysActivity()
    }

    private var providerPie: [(name: String, value: Double, color: Color)] {
        store.monthlyBreakdown().map { item in
            (
                name: item.provider.displayName,
                value: Double(item.conversations),
                color: providerColor(item.provider)
            )
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Analytics")
                    .font(.largeTitle.bold())
                    .padding(.top, 8)

                // Conversations over 30 days
                VStack(alignment: .leading, spacing: 12) {
                    Text("Conversations — Last 30 Days")
                        .font(.headline)

                    Chart(conversationsByDay, id: \.date) { item in
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            y: .value("Conversations", item.count)
                        )
                        .foregroundStyle(.blue.gradient)
                        .cornerRadius(3)
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 7)) {
                            AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                        }
                    }
                    .frame(height: 160)
                }
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                // Cost by provider — pie
                if !providerPie.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Conversations by Provider (This Month)")
                            .font(.headline)

                        HStack(spacing: 24) {
                            Chart(providerPie, id: \.name) { item in
                                SectorMark(
                                    angle: .value("Conversations", item.value),
                                    innerRadius: .ratio(0.55),
                                    angularInset: 2
                                )
                                .foregroundStyle(item.color)
                            }
                            .frame(width: 140, height: 140)

                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(providerPie, id: \.name) { item in
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(item.color)
                                            .frame(width: 10, height: 10)
                                        Text(item.name)
                                            .font(.subheadline)
                                        Spacer()
                                        Text("\(Int(item.value))")
                                            .font(.subheadline.monospacedDigit())
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                // Tokens over time
                if !store.filteredEntries.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Token Estimates — All Time")
                            .font(.headline)

                        Chart(store.filteredEntries.prefix(60).reversed(), id: \.id) { entry in
                            LineMark(
                                x: .value("Date", entry.date),
                                y: .value("Tokens", entry.tokensEstimate)
                            )
                            .foregroundStyle(.orange.gradient)
                            .interpolationMethod(.catmullRom)

                            AreaMark(
                                x: .value("Date", entry.date),
                                y: .value("Tokens", entry.tokensEstimate)
                            )
                            .foregroundStyle(.orange.opacity(0.15).gradient)
                            .interpolationMethod(.catmullRom)
                        }
                        .chartYAxis {
                            AxisMarks {
                                AxisValueLabel()
                            }
                        }
                        .frame(height: 160)
                    }
                    .padding(16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                if store.filteredEntries.isEmpty {
                    ContentUnavailableView(
                        "No data to chart",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Add entries to see charts.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }
            }
            .padding(24)
        }
        .navigationTitle("Charts")
    }

    private func providerColor(_ provider: AIProvider) -> Color {
        switch provider {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }
}
