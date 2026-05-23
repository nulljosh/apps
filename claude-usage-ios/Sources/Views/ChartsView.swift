import SwiftUI
import Charts

struct ChartsView: View {
    @Environment(UsageStore.self) private var store

    private var conversationsByDay: [(date: Date, count: Int)] {
        store.last30DaysActivity()
    }

    private var providerPie: [(name: String, value: Double, color: Color)] {
        store.monthlyBreakdown().map { item in
            (item.provider.displayName, Double(item.conversations), item.provider.color)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if store.filteredEntries.isEmpty {
                        ContentUnavailableView(
                            "No data to chart",
                            systemImage: "chart.line.uptrend.xyaxis",
                            description: Text("Add entries to see charts.")
                        )
                        .padding(.top, 60)
                    } else {
                        // Conversations bar chart
                        ChartCard(title: "Conversations — Last 30 Days") {
                            Chart(conversationsByDay, id: \.date) { item in
                                BarMark(
                                    x: .value("Date", item.date, unit: .day),
                                    y: .value("Conversations", item.count)
                                )
                                .foregroundStyle(Color.accentColor.gradient)
                                .cornerRadius(3)
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day, count: 7)) {
                                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                                        .font(.caption2)
                                }
                            }
                            .frame(height: 140)
                        }

                        // Provider pie
                        if !providerPie.isEmpty {
                            ChartCard(title: "Conversations by Provider") {
                                HStack(spacing: 20) {
                                    Chart(providerPie, id: \.name) { item in
                                        SectorMark(
                                            angle: .value("Conversations", item.value),
                                            innerRadius: .ratio(0.55),
                                            angularInset: 2
                                        )
                                        .foregroundStyle(item.color)
                                    }
                                    .frame(width: 110, height: 110)

                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(providerPie, id: \.name) { item in
                                            HStack(spacing: 8) {
                                                Circle().fill(item.color).frame(width: 8, height: 8)
                                                Text(item.name).font(.caption)
                                                Spacer()
                                                Text("\(Int(item.value))")
                                                    .font(.caption.monospacedDigit())
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Token trend
                        ChartCard(title: "Token Estimates") {
                            Chart(Array(store.filteredEntries.prefix(60).reversed()), id: \.id) { entry in
                                LineMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Tokens", entry.tokensEstimate)
                                )
                                .foregroundStyle(Color.orange.gradient)
                                .interpolationMethod(.catmullRom)

                                AreaMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Tokens", entry.tokensEstimate)
                                )
                                .foregroundStyle(Color.orange.opacity(0.1).gradient)
                                .interpolationMethod(.catmullRom)
                            }
                            .frame(height: 120)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .navigationTitle("Charts")
        }
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)
            content()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
