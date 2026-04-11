import SwiftUI

struct TimelineView: View {
    @Environment(CalendarService.self) private var cal
    @Environment(CustomSourceService.self) private var custom

    private var allEvents: [FuseEvent] {
        (cal.events + custom.events)
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
    }

    private var grouped: [(date: Date, events: [FuseEvent])] {
        var map: [(Date, [FuseEvent])] = []
        var seen: [String: Int] = [:]
        for e in allEvents {
            let key = Calendar.current.startOfDay(for: e.date).description
            if let idx = seen[key] {
                map[idx].1.append(e)
            } else {
                seen[key] = map.count
                map.append((Calendar.current.startOfDay(for: e.date), [e]))
            }
        }
        return map.map { (date: $0.0, events: $0.1) }
    }

    private var totalSpan: TimeInterval {
        guard let last = allEvents.last else { return 1 }
        return max(1, last.date.timeIntervalSinceNow)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    heatStrip

                    if let next = allEvents.first {
                        nextUpHero(next)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }

                    ForEach(grouped, id: \.date) { group in
                        daySection(group)
                    }
                }
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .navigationTitle("timeline")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: Heat strip
    private var heatStrip: some View {
        let cells: [Int] = (0..<30).map { i in
            let start = Calendar.current.date(byAdding: .day, value: i, to: Calendar.current.startOfDay(for: Date()))!
            let end   = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            return allEvents.filter { $0.date >= start && $0.date < end }.count
        }
        let maxVal = cells.max() ?? 1

        return VStack(alignment: .leading, spacing: 6) {
            Text("next 30 days")
                .font(.system(size: 10, weight: .medium))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(.tertiary)
            HStack(spacing: 2) {
                ForEach(0..<30, id: \.self) { i in
                    let count = cells[i]
                    let intensity = maxVal > 0 ? Double(count) / Double(maxVal) : 0
                    RoundedRectangle(cornerRadius: 3)
                        .fill(heatColor(intensity))
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func heatColor(_ intensity: Double) -> Color {
        if intensity == 0 { return Color.white.opacity(0.05) }
        if intensity > 0.7 { return Color.red.opacity(0.6) }
        if intensity > 0.4 { return Color.orange.opacity(0.5) }
        return Color.blue.opacity(0.4)
    }

    // MARK: Next up hero
    private func nextUpHero(_ event: FuseEvent) -> some View {
        VStack(spacing: 12) {
            Text("next up")
                .font(.system(size: 10, weight: .semibold))
                .tracking(2.5)
                .textCase(.uppercase)
                .foregroundStyle(Color.red)
            Text(event.title)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
            CountdownView(event: event, large: true)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }

    // MARK: Day section
    private func daySection(_ group: (date: Date, events: [FuseEvent])) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(group.date.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.system(size: 20, weight: .bold))
                Text(dayLabel(group.date))
                    .font(.system(size: 11, weight: .medium))
                    .tracking(1)
                    .textCase(.uppercase)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)

            ForEach(group.events) { event in
                EventCardView(event: event, totalSpan: totalSpan)
                    .padding(.horizontal, 16)
            }
        }
    }

    private func dayLabel(_ date: Date) -> String {
        let diff = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: date).day ?? 0
        switch diff {
        case 0: return "today"
        case 1: return "tomorrow"
        case 2...6: return date.formatted(.dateTime.weekday(.wide))
        default: return date.formatted(.dateTime.weekday(.abbreviated))
        }
    }
}
