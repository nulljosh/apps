import SwiftUI
import Charts

private func chartTitle(_ text: String) -> some View {
    Text(text)
        .font(.system(size: 11, weight: .medium))
        .tracking(0.8)
        .foregroundStyle(.secondary)
}

// MARK: - Original charts (top of document)

struct ChartsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            StabilityChart()
            EventsBarChart()
        }
    }
}

// MARK: - Chart 1: Stability Over Time

struct StabilityChart: View {
    private let data = LifeData.stability
    @State private var selectedYear: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("STABILITY OVER TIME")

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
                .symbolSize(selectedYear == point.year ? 80 : 30)

                if selectedYear == point.year {
                    RuleMark(x: .value("Year", point.year))
                        .foregroundStyle(.tertiary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .annotation(position: .top, alignment: .center) {
                            Text("\(point.year) - \(point.label)")
                                .font(.system(size: 10, weight: .medium))
                                .padding(6)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                        }
                }
            }
            .chartXScale(domain: 1999...2026)
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
                AxisMarks(values: [1999, 2007, 2014, 2019, 2024, 2026]) { value in
                    AxisValueLabel {
                        if let y = value.as(Int.self) {
                            Text(y == 1999 ? "1999" : "'\(String(y).suffix(2))")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let x = value.location.x - origin.x
                                if let year: Int = proxy.value(atX: x) {
                                    let nearest = data.min(by: { abs($0.year - year) < abs($1.year - year) })
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedYear = selectedYear == nearest?.year ? nil : nearest?.year
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 180)
        }
    }
}

// MARK: - Chart 2: Events by Life Phase

struct EventsBarChart: View {
    private let data = LifeData.phases
    @State private var selectedPhase: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("EVENTS BY LIFE PHASE")

            Chart(data) { phase in
                BarMark(
                    x: .value("Count", phase.count),
                    y: .value("Phase", phase.phase)
                )
                .foregroundStyle(phase.category.color.opacity(selectedPhase == phase.phase ? 1.0 : 0.7))
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let y = value.location.y - origin.y
                                if let phase: String = proxy.value(atY: y) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedPhase = selectedPhase == phase ? nil : phase
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 140)

            if let phase = selectedPhase, let item = data.first(where: { $0.phase == phase }) {
                Text("\(item.phase): \(item.count) events (ages \(item.ages))")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Chart 3: Aggression Timeline

struct AggressionChart: View {
    private let data = LifeData.aggression
    @State private var selectedLabel: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("AGGRESSION OVER TIME")

            Chart(data) { period in
                BarMark(
                    xStart: .value("Start", period.startAge),
                    xEnd: .value("End", period.endAge),
                    y: .value("Type", period.label)
                )
                .foregroundStyle(period.category.color.opacity(
                    selectedLabel == period.label ? 0.9 :
                    period.category == .forward ? 0.6 : 0.7
                ))
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let y = value.location.y - origin.y
                                if let label: String = proxy.value(atY: y) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedLabel = selectedLabel == label ? nil : label
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 100)

            if let label = selectedLabel, let period = data.first(where: { $0.label == label }) {
                Text("\(period.label): ages \(period.startAge)-\(period.endAge)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            } else if let detail = data.compactMap(\.detail).first {
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
    @State private var selectedTrigger: String?
    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("TRIGGER INTENSITY")

            HStack(spacing: 0) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, trigger in
                    VStack(spacing: 8) {
                        Circle()
                            .fill(TimelineCategory.crisis.color.opacity(0.2))
                            .frame(
                                width: CGFloat(trigger.intensity * 60),
                                height: CGFloat(trigger.intensity * 60)
                            )
                            .overlay(
                                Circle()
                                    .fill(TimelineCategory.crisis.color)
                                    .frame(width: 6, height: 6)
                            )
                            .scaleEffect(appeared ? (selectedTrigger == trigger.label ? 1.15 : 1.0) : 0)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.6)
                                    .delay(Double(index) * 0.08),
                                value: appeared
                            )

                        Text(trigger.label)
                            .font(.system(size: 10, weight: .medium))

                        Text(trigger.detail)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTrigger = selectedTrigger == trigger.label ? nil : trigger.label
                        }
                    }
                }
            }
            .frame(height: 120)
            .onAppear { appeared = true }
        }
    }
}

// MARK: - Chart 5: Diagnosis Gap

struct DiagnosisGapChart: View {
    private let earlyMilestones = LifeData.diagnosisMilestones.filter { $0.age == 8 }
    private let lateMilestones = LifeData.diagnosisMilestones.filter { $0.age >= 25 }
    @State private var selectedCluster: String?
    @State private var gapPulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("DIAGNOSIS AND TREATMENT TIMELINE")

            HStack(alignment: .center, spacing: 0) {
                // Age 8 cluster
                VStack(spacing: 4) {
                    Text("Age 8")
                        .font(.system(size: 11, weight: .semibold))
                    ForEach(earlyMilestones) { m in
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
                .scaleEffect(selectedCluster == "early" ? 1.05 : 1.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedCluster = selectedCluster == "early" ? nil : "early"
                    }
                }

                // Gap
                VStack(spacing: 4) {
                    Text("17 years")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.red.opacity(0.6))
                        .scaleEffect(gapPulse ? 1.05 : 1.0)
                    Text("no diagnosis, no consistent treatment")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Rectangle()
                        .fill(.red.opacity(0.2))
                        .frame(height: 1)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        gapPulse = true
                    }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.2)) {
                        gapPulse = false
                    }
                }

                // Age 25-26 cluster
                VStack(spacing: 4) {
                    Text("Age 25-26")
                        .font(.system(size: 11, weight: .semibold))
                    ForEach(lateMilestones) { m in
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
                .scaleEffect(selectedCluster == "late" ? 1.05 : 1.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedCluster = selectedCluster == "late" ? nil : "late"
                    }
                }
            }
            .frame(height: 140)
        }
    }
}

// MARK: - Chart 6: Relationship Periods

struct RelationshipChart: View {
    private let data = LifeData.relationships
    @State private var selectedName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("RELATIONSHIP PERIODS")

            Chart(data) { r in
                BarMark(
                    xStart: .value("Start", r.startYear),
                    xEnd: .value("End", r.endYear == r.startYear ? r.startYear + 1 : r.endYear),
                    y: .value("Name", r.name)
                )
                .foregroundStyle(r.category.color.opacity(selectedName == r.name ? 0.9 : 0.6))
                .cornerRadius(3)
                .annotation(position: .trailing) {
                    Text(r.detail)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }

                if selectedName == r.name {
                    RuleMark(y: .value("Name", r.name))
                        .foregroundStyle(.clear)
                        .annotation(position: .overlay, alignment: .center) {
                            Text("\(r.name): \(r.startYear)-\(r.endYear)")
                                .font(.system(size: 9, weight: .medium))
                                .padding(4)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 4))
                        }
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let y = value.location.y - origin.y
                                if let name: String = proxy.value(atY: y) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedName = selectedName == name ? nil : name
                                    }
                                }
                            }
                        )
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
    @State private var selectedYear: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("SOCIAL CIRCLE OVER TIME")

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
                .symbolSize(selectedYear == point.year ? 80 : 30)
                .annotation(position: .top) {
                    Text(point.label)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }

                if selectedYear == point.year {
                    RuleMark(x: .value("Year", point.year))
                        .foregroundStyle(.tertiary)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                }
            }
            .chartXScale(domain: 2004...2027)
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
                AxisMarks(values: [2005, 2014, 2018, 2020, 2024, 2026]) { value in
                    AxisValueLabel {
                        if let y = value.as(Int.self) {
                            Text("'\(String(y).suffix(2))")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let x = value.location.x - origin.x
                                if let year: Int = proxy.value(atX: x) {
                                    let nearest = data.min(by: { abs($0.year - year) < abs($1.year - year) })
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedYear = selectedYear == nearest?.year ? nil : nearest?.year
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 160)
        }
    }
}

// MARK: - Chart 8: Housing Stability

struct HousingChart: View {
    private let data = LifeData.housing
    @State private var selectedLabel: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("HOUSING STABILITY")

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
                .symbolSize(selectedLabel == state.label ? 80 : 40)
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let x = value.location.x - origin.x
                                if let label: String = proxy.value(atX: x) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedLabel = selectedLabel == label ? nil : label
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 140)

            if let label = selectedLabel, let state = data.first(where: { $0.label == label }) {
                Text("\(state.label) (\(state.year)): \(state.level >= 0.8 ? "Stable" : state.level >= 0.4 ? "Unstable" : "None")")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Chart 9: Coping Mechanisms

struct CopingChart: View {
    private let data = LifeData.coping
    @State private var selectedCoping: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("COPING MECHANISMS")

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
                                    .fill(Color.green.opacity(selectedCoping == item.label ? 0.8 : 0.5))
                                    .frame(width: barWidth, height: 14)
                                Spacer(minLength: 0)
                            }
                        } else {
                            HStack(spacing: 0) {
                                Spacer(minLength: 0)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.red.opacity(selectedCoping == item.label ? 0.8 : 0.5))
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
                .scaleEffect(selectedCoping == item.label ? 1.02 : 1.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedCoping = selectedCoping == item.label ? nil : item.label
                    }
                }
            }
        }
    }
}

// MARK: - Chart 10: Daily Routine

struct DailyRoutineChart: View {
    private let data = LifeData.dailyRoutine
    private let totalHours: Double = 24
    @State private var selectedSegment: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            chartTitle("TYPICAL DAY")

            ForEach(data) { segment in
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        Text(segment.label)
                            .font(.system(size: 11, weight: .medium))
                            .frame(width: 60, alignment: .trailing)

                        GeometryReader { geo in
                            let barWidth = geo.size.width * (segment.hours / totalHours)
                            HStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(segment.category == .forward
                                          ? Color.green.opacity(selectedSegment == segment.label ? 0.9 : 0.6)
                                          : Color.primary.opacity(selectedSegment == segment.label ? 0.3 : 0.15))
                                    .frame(width: barWidth, height: 20)
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(height: 20)

                        Text("~\(Int(segment.hours))h")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 30, alignment: .leading)
                    }

                    if selectedSegment == segment.label {
                        Text("\(segment.label): ~\(Int(segment.hours)) hours per day")
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 72)
                            .transition(.scale(scale: 0.95).combined(with: .opacity))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedSegment = selectedSegment == segment.label ? nil : segment.label
                    }
                }
            }

            // Weed overlay note
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(.red.opacity(0.3))
                    .frame(width: 16, height: 3)
                Text("weed + vaping throughout the day")
                    .font(.system(size: 9))
                    .foregroundStyle(.red.opacity(0.5))
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Chart 11: Sensory Heatmap

struct SensoryHeatmapChart: View {
    private let data = LifeData.sensoryProfile
    @State private var selectedSense: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("SENSORY PROFILE")

            ForEach(data) { item in
                HStack(spacing: 10) {
                    Text(item.sense)
                        .font(.system(size: 10, weight: .medium))
                        .frame(width: 90, alignment: .trailing)

                    GeometryReader { geo in
                        let barWidth = geo.size.width * item.intensity
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.orange.opacity(
                                    selectedSense == item.sense
                                    ? 0.3 + item.intensity * 0.6
                                    : 0.15 + item.intensity * 0.5
                                ))
                                .frame(width: barWidth, height: 20)
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(height: 20)

                    Text(item.detail)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .frame(width: 100, alignment: .leading)
                        .lineLimit(2)
                }
                .scaleEffect(selectedSense == item.sense ? 1.02 : 1.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedSense = selectedSense == item.sense ? nil : item.sense
                    }
                }
            }
        }
    }
}

// MARK: - Chart 12: Sleep Quality

struct SleepQualityChart: View {
    private let data = LifeData.sleepPhases
    @State private var selectedPhase: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("SLEEP QUALITY OVER TIME")

            Chart(data) { phase in
                LineMark(
                    x: .value("Phase", phase.phase),
                    y: .value("Quality", phase.quality)
                )
                .foregroundStyle(Color.indigo.opacity(0.6))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Phase", phase.phase),
                    y: .value("Quality", phase.quality)
                )
                .foregroundStyle(Color.indigo.opacity(0.06))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Phase", phase.phase),
                    y: .value("Quality", phase.quality)
                )
                .foregroundStyle(phase.category.color)
                .symbolSize(selectedPhase == phase.phase ? 80 : 30)
                .annotation(position: .top) {
                    Text(phase.years)
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
                            Text(v == 0 ? "Poor" : v == 0.5 ? "Fair" : "Good")
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let x = value.location.x - origin.x
                                if let phase: String = proxy.value(atX: x) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedPhase = selectedPhase == phase ? nil : phase
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 160)

            if let phase = selectedPhase, let item = data.first(where: { $0.phase == phase }) {
                Text("\(item.phase) (\(item.years)): \(Int(item.quality * 100))% quality")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Chart 13: Financial Timeline

struct FinancialTimelineChart: View {
    private let data = LifeData.financialTimeline
    @State private var selectedLabel: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("FINANCIAL TIMELINE")

            ForEach(data) { period in
                HStack(spacing: 12) {
                    Circle()
                        .fill(period.category.color)
                        .frame(width: 8, height: 8)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(period.label)
                                .font(.system(size: 11, weight: .semibold))
                            Text(period.years)
                                .font(.system(size: 9))
                                .foregroundStyle(.tertiary)
                        }
                        Text(period.source)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(period.category.color.opacity(selectedLabel == period.label ? 0.1 : 0.0))
                )
                .scaleEffect(selectedLabel == period.label ? 1.02 : 1.0)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedLabel = selectedLabel == period.label ? nil : period.label
                    }
                }
            }
        }
    }
}

// MARK: - Chart 14: Substance Use

struct SubstanceChart: View {
    private let data = LifeData.substanceTimeline
    @State private var selectedAge: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("SUBSTANCE USE OVER TIME")

            Chart(data) { point in
                AreaMark(
                    x: .value("Age", point.age),
                    y: .value("Weed", point.weedIntensity)
                )
                .foregroundStyle(Color.green.opacity(0.15))
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Age", point.age),
                    y: .value("Weed", point.weedIntensity)
                )
                .foregroundStyle(Color.green.opacity(0.7))
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Age", point.age),
                    y: .value("Vaping", point.vapingIntensity)
                )
                .foregroundStyle(Color.blue.opacity(0.1))
                .interpolationMethod(.catmullRom)

                LineMark(
                    x: .value("Age", point.age),
                    y: .value("Vaping", point.vapingIntensity)
                )
                .foregroundStyle(Color.blue.opacity(0.5))
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                PointMark(
                    x: .value("Age", point.age),
                    y: .value("Weed", point.weedIntensity)
                )
                .foregroundStyle(Color.green)
                .symbolSize(selectedAge == point.age ? 60 : 20)
            }
            .chartXScale(domain: 17...27)
            .chartYScale(domain: 0...1)
            .chartYAxis {
                AxisMarks(values: [0.0, 0.5, 1.0]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4, 4]))
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(v == 0 ? "None" : v == 0.5 ? "Moderate" : "Heavy")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: [17, 19, 21, 23, 25, 27]) { value in
                    AxisValueLabel {
                        if let age = value.as(Int.self) {
                            Text("age \(age)")
                                .font(.system(size: 9))
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let x = value.location.x - origin.x
                                if let age: Int = proxy.value(atX: x) {
                                    let nearest = data.min(by: { abs($0.age - age) < abs($1.age - age) })
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedAge = selectedAge == nearest?.age ? nil : nearest?.age
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 160)

            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Circle().fill(Color.green).frame(width: 6, height: 6)
                    Text("Weed").font(.system(size: 9)).foregroundStyle(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.blue.opacity(0.5)).frame(width: 6, height: 6)
                    Text("Vaping").font(.system(size: 9)).foregroundStyle(.secondary)
                }
            }

            if let age = selectedAge, let point = data.first(where: { $0.age == age }) {
                Text("Age \(point.age): \(point.label)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Chart 15: Strengths

struct StrengthsChart: View {
    private let data = LifeData.strengths
    @State private var selectedLabel: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            chartTitle("STRENGTHS")

            Chart(data) { item in
                BarMark(
                    x: .value("Intensity", item.intensity),
                    y: .value("Strength", item.label)
                )
                .foregroundStyle(Color.green.opacity(selectedLabel == item.label ? 0.8 : 0.5))
                .cornerRadius(3)
                .annotation(position: .trailing) {
                    Text("\(Int(item.intensity * 100))%")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: 0...1.15)
            .chartXAxis(.hidden)
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
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let origin = geo[proxy.plotFrame!].origin
                                let y = value.location.y - origin.y
                                if let label: String = proxy.value(atY: y) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedLabel = selectedLabel == label ? nil : label
                                    }
                                }
                            }
                        )
                }
            }
            .frame(height: 160)
        }
    }
}

// MARK: - Pull Quote

struct PullQuoteView: View {
    let text: String
    @State private var appeared = false

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
            .opacity(appeared ? 1.0 : 0)
            .offset(y: appeared ? 0 : 12)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    appeared = true
                }
            }
    }
}

// MARK: - Stats Grid

struct StatsGridView: View {
    private let data = LifeData.stats
    @State private var appeared = false

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ], spacing: 20) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, stat in
                VStack(spacing: 4) {
                    Text(stat.number)
                        .font(.system(size: 36, weight: .bold))
                        .tracking(-1)
                        .scaleEffect(appeared ? 1.0 : 0.5)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.6)
                                .delay(Double(index) * 0.08),
                            value: appeared
                        )
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
        .onAppear { appeared = true }
    }
}

// MARK: - Map

struct LifeMapView: View {
    private let bcLocations = LifeData.mapLocations.filter { !$0.isOffMap }
    private let offMapLocations = LifeData.mapLocations.filter { $0.isOffMap }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            chartTitle("GEOGRAPHY")

            ForEach(bcLocations) { loc in
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(loc.category.color.opacity(0.15))
                            .frame(width: 36, height: 36)
                        Circle()
                            .fill(loc.category.color)
                            .frame(width: 10, height: 10)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.name)
                            .font(.system(size: 14, weight: .semibold))
                        Text(loc.detail)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }
                }
            }

            Rectangle()
                .fill(.tertiary)
                .frame(height: 0.5)
                .padding(.vertical, 4)

            Text("BEYOND BC")
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.tertiary)
                .tracking(0.8)

            HStack(spacing: 20) {
                ForEach(offMapLocations) { loc in
                    VStack(spacing: 6) {
                        Circle()
                            .fill(loc.category.color.opacity(0.3))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .fill(loc.category.color)
                                    .frame(width: 6, height: 6)
                            )
                        Text(loc.name)
                            .font(.system(size: 10, weight: .medium))
                        Text(loc.detail)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
