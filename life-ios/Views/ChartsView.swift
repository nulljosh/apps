import SwiftUI
import Charts

struct ChartsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            StabilityChart()
            EventsBarChart()
        }
    }
}

struct StabilityChart: View {
    private let data = LifeData.stability

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("STABILITY OVER TIME")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { point in
                LineMark(
                    x: .value("Year", point.year),
                    y: .value("Stability", point.score)
                )
                .foregroundStyle(TimelineCategory.forward.color.opacity(0.8))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Year", point.year),
                    y: .value("Stability", point.score)
                )
                .foregroundStyle(TimelineCategory.forward.color.opacity(0.06))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Year", point.year),
                    y: .value("Stability", point.score)
                )
                .foregroundStyle(point.category.color)
                .symbolSize(30)
            }
            .chartYScale(domain: 0...1)
            .chartYAxis {
                AxisMarks(values: [0.0, 0.5, 1.0]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(v == 0 ? "Low" : v == 0.5 ? "Mid" : "High")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: data.map(\.year)) { value in
                    AxisValueLabel {
                        if let y = value.as(Int.self) {
                            Text(y == 1999 ? "1999" : "'\(String(y).suffix(2))")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .frame(height: 180)
        }
    }
}

struct EventsBarChart: View {
    private let data = LifeData.phases

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("EVENTS BY LIFE PHASE")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { phase in
                BarMark(
                    x: .value("Count", phase.count),
                    y: .value("Phase", phase.phase)
                )
                .foregroundStyle(phase.category.color.opacity(0.7))
                .cornerRadius(3)
                .annotation(position: .trailing) {
                    Text("\(phase.count)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: 0...5)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let phase = value.as(String.self),
                           let item = data.first(where: { $0.phase == phase }) {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(phase)
                                    .font(.system(size: 11, weight: .medium))
                                Text("ages \(item.ages)")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
            .frame(height: 140)
        }
    }
}
