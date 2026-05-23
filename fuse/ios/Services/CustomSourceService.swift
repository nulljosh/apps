import Foundation
import Observation

@Observable
final class CustomSourceService {
    var events: [FuseEvent] = []

    init() { build() }

    private func build() {
        var result: [FuseEvent] = []
        if let payday = nextPayday() {
            result.append(FuseEvent(
                id: "tally-payday",
                title: "Payday",
                date: payday,
                category: .payday,
                source: "tally",
                isAllDay: false,
                calendarColor: "#34c759"
            ))
        }
        events = result
    }

    // BC Income Assistance: last Wednesday of each month
    private func nextPayday() -> Date? {
        let cal = Calendar.current
        let now = Date()
        for monthOffset in 0...1 {
            guard let monthStart = cal.date(byAdding: .month, value: monthOffset, to: now),
                  let range = cal.range(of: .day, in: .month, for: monthStart),
                  let lastDay = cal.date(from: cal.dateComponents([.year, .month], from: monthStart))
                      .flatMap({ cal.date(byAdding: .day, value: range.count - 1, to: $0) })
            else { continue }

            // Walk back from last day to find Wednesday (weekday 4 in 1-indexed Sunday-first)
            for offset in 0..<7 {
                guard let candidate = cal.date(byAdding: .day, value: -offset, to: lastDay) else { continue }
                if cal.component(.weekday, from: candidate) == 4 {
                    var comps = cal.dateComponents([.year, .month, .day], from: candidate)
                    comps.hour = 9
                    if let date = cal.date(from: comps), date > now {
                        return date
                    }
                    break
                }
            }
        }
        return nil
    }
}
