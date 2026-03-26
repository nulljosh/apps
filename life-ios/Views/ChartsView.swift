import SwiftUI
import Charts

// MARK: - Original charts (top of document)

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

// MARK: - Chart 3: Aggression Timeline

struct AggressionChart: View {
    private let data = LifeData.aggression

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AGGRESSION OVER TIME")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { period in
                BarMark(
                    xStart: .value("Start", period.startAge),
                    xEnd: .value("End", period.endAge),
                    y: .value("Type", period.label)
                )
                .foregroundStyle(period.category.color.opacity(period.category == .forward ? 0.6 : 0.7))
                .cornerRadius(3)
            }
            .chartXScale(domain: 0...26)
            .chartXAxis {
                AxisMarks(values: [0, 5, 10, 15, 21, 26]) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("age \(v)")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let label = value.as(String.self) {
                            Text(label)
                                .font(.system(size: 10, weight: .medium))
                        }
                    }
                }
            }
            .frame(height: 100)

            if let verbal = data.first(where: { $0.label == "Verbal + intimidation" }),
               let detail = verbal.detail {
                Text(detail)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
}

// MARK: - Chart 4: Trigger Intensity

struct TriggersChart: View {
    private let data = LifeData.triggers

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TRIGGER INTENSITY")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            HStack(spacing: 0) {
                ForEach(data) { trigger in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(TimelineCategory.crisis.color.opacity(0.2))
                            .frame(width: CGFloat(trigger.intensity * 60), height: CGFloat(trigger.intensity * 60))
                            .overlay(
                                Circle()
                                    .fill(TimelineCategory.crisis.color)
                                    .frame(width: 6, height: 6)
                            )

                        Text(trigger.label)
                            .font(.system(size: 10, weight: .medium))

                        Text(trigger.detail)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120)
        }
    }
}

// MARK: - Chart 5: Diagnosis Gap

struct DiagnosisGapChart: View {
    private let data = LifeData.diagnosisMilestones

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DIAGNOSIS AND TREATMENT TIMELINE")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            HStack(alignment: .center, spacing: 0) {
                // Age 8 cluster
                VStack(spacing: 4) {
                    Text("Age 8")
                        .font(.system(size: 11, weight: .semibold))
                    ForEach(data.filter { $0.age == 8 }) { m in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(m.category.color)
                                .frame(width: 6, height: 6)
                            Text(m.label)
                                .font(.system(size: 9))
                        }
                    }
                }
                .frame(maxWidth: .infinity)

                // Gap
                VStack(spacing: 4) {
                    Text("17 years")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.red.opacity(0.6))
                    Text("no diagnosis, no consistent treatment")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Rectangle()
                        .fill(.red.opacity(0.2))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)

                // Age 25-26 cluster
                VStack(spacing: 4) {
                    Text("Age 25-26")
                        .font(.system(size: 11, weight: .semibold))
                    ForEach(data.filter { $0.age >= 25 }) { m in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(m.category.color)
                                .frame(width: 6, height: 6)
                            Text(m.label)
                                .font(.system(size: 9))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 140)
        }
    }
}

// MARK: - Chart 6: Relationship Periods

struct RelationshipChart: View {
    private let data = LifeData.relationships

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("RELATIONSHIP PERIODS")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { r in
                BarMark(
                    xStart: .value("Start", r.startYear),
                    xEnd: .value("End", r.endYear == r.startYear ? r.startYear + 1 : r.endYear),
                    y: .value("Name", r.name)
                )
                .foregroundStyle(r.category.color.opacity(0.6))
                .cornerRadius(3)
                .annotation(position: .trailing) {
                    Text(r.detail)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: 2013...2026)
            .chartXAxis {
                AxisMarks(values: [2014, 2017, 2019, 2021, 2023, 2026]) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let y = value.as(Int.self) {
                            Text("'\(String(y).suffix(2))")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let name = value.as(String.self) {
                            Text(name)
                                .font(.system(size: 10, weight: .medium))
                        }
                    }
                }
            }
            .frame(height: 100)

            HStack(spacing: 4) {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundStyle(.secondary)
                    .frame(width: 30, height: 1)
                Text("done")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Chart 7: Social Circle

struct SocialCircleChart: View {
    private let data = LifeData.socialCircle

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SOCIAL CIRCLE OVER TIME")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { point in
                LineMark(
                    x: .value("Year", point.year),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(Color.primary.opacity(0.5))
                .interpolationMethod(.linear)

                AreaMark(
                    x: .value("Year", point.year),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(Color.primary.opacity(0.04))
                .interpolationMethod(.linear)

                PointMark(
                    x: .value("Year", point.year),
                    y: .value("Count", point.count)
                )
                .foregroundStyle(point.category.color)
                .symbolSize(30)
                .annotation(position: .top) {
                    Text(point.label)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...1)
            .chartYAxis {
                AxisMarks(values: [0.0, 0.5, 1.0]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(v == 0 ? "0" : v == 0.5 ? "Few" : "Many")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: data.map(\.year)) { value in
                    AxisValueLabel {
                        if let y = value.as(Int.self) {
                            Text("'\(String(y).suffix(2))")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .frame(height: 160)
        }
    }
}

// MARK: - Chart 8: Housing Stability

struct HousingChart: View {
    private let data = LifeData.housing

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("HOUSING STABILITY")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { state in
                LineMark(
                    x: .value("Period", state.label),
                    y: .value("Stability", state.level)
                )
                .foregroundStyle(Color.primary.opacity(0.5))
                .interpolationMethod(.stepCenter)

                PointMark(
                    x: .value("Period", state.label),
                    y: .value("Stability", state.level)
                )
                .foregroundStyle(state.category.color)
                .symbolSize(40)
                .annotation(position: state.level < 0.5 ? .bottom : .top) {
                    Text(state.year)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...1)
            .chartYAxis {
                AxisMarks(values: [0.0, 0.5, 1.0]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(v == 0 ? "None" : v == 0.5 ? "Unstable" : "Stable")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let label = value.as(String.self) {
                            Text(label)
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .frame(height: 140)
        }
    }
}

// MARK: - Chart 9: Coping Mechanisms

struct CopingChart: View {
    private let data = LifeData.coping

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("COPING MECHANISMS")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                Text("Self-destructive")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.red.opacity(0.7))
                Spacer()
                Text("Healthy")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.green)
            }

            ForEach(data) { item in
                HStack(spacing: 8) {
                    Text(item.label)
                        .font(.system(size: 10, weight: .medium))
                        .frame(width: 80, alignment: .trailing)

                    GeometryReader { geo in
                        let barWidth = geo.size.width * item.intensity
                        if item.isHealthy {
                            HStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.green.opacity(0.5))
                                    .frame(width: barWidth, height: 14)
                                Spacer(minLength: 0)
                            }
                        } else {
                            HStack(spacing: 0) {
                                Spacer(minLength: 0)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.red.opacity(0.5))
                                    .frame(width: barWidth, height: 14)
                            }
                        }
                    }
                    .frame(height: 14)

                    Text(item.detail)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .frame(width: 90, alignment: .leading)
                        .lineLimit(1)
                }
            }
        }
    }
}

// MARK: - Chart 10: Daily Routine

struct DailyRoutineChart: View {
    private let data = LifeData.dailyRoutine

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TYPICAL DAY")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            Chart(data) { segment in
                BarMark(
                    x: .value("Hours", segment.hours),
                    y: .value("Day", "24h")
                )
                .foregroundStyle(segment.category == .forward ? Color.green.opacity(0.5) : Color.primary.opacity(0.2))
                .cornerRadius(0)
                .annotation(position: .overlay) {
                    Text("\(segment.label) ~\(Int(segment.hours))h")
                        .font(.system(size: 8))
                        .foregroundStyle(.primary)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 36)

            HStack(spacing: 4) {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 5]))
                    .foregroundStyle(.red.opacity(0.4))
                    .frame(width: 20, height: 1)
                Text("weed + vaping throughout")
                    .font(.system(size: 8))
                    .foregroundStyle(.red.opacity(0.5))
            }
        }
    }
}

// MARK: - Pull Quote

struct PullQuoteView: View {
    let text: String

    var body: some View {
        Text("\"\(text)\"")
            .font(.system(size: 20, weight: .light))
            .lineSpacing(6)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .top) {
                Rectangle().fill(.tertiary).frame(height: 0.5)
            }
            .overlay(alignment: .bottom) {
                Rectangle().fill(.tertiary).frame(height: 0.5)
            }
    }
}

// MARK: - Stats Grid

struct StatsGridView: View {
    private let data = LifeData.stats

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ], spacing: 20) {
            ForEach(data) { stat in
                VStack(spacing: 4) {
                    Text(stat.number)
                        .font(.system(size: 36, weight: .bold))
                        .tracking(-1)
                    Text(stat.label)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.5)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.vertical, 24)
        .overlay(alignment: .top) {
            Rectangle().fill(.tertiary).frame(height: 0.5)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(.tertiary).frame(height: 0.5)
        }
    }
}

// MARK: - Map

struct LifeMapView: View {
    private let bcLocations = LifeData.mapLocations.filter { !$0.isOffMap }
    private let offMapLocations = LifeData.mapLocations.filter { $0.isOffMap }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("GEOGRAPHY")
                .font(.system(size: 11, weight: .medium))
                .tracking(0.8)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(bcLocations) { loc in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(loc.category.color)
                            .frame(width: 10, height: 10)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(loc.name)
                                .font(.system(size: 12, weight: .semibold))
                            Text(loc.detail)
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Divider()

                Text("Beyond BC")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                ForEach(offMapLocations) { loc in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(loc.category.color.opacity(0.4))
                            .frame(width: 8, height: 8)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(loc.name)
                                .font(.system(size: 11))
                            Text(loc.detail)
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}
