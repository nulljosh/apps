import Foundation
import EventKit
import Observation

@Observable
final class CalendarServiceMac {
    var events: [FuseEventMac] = []
    var error: String?

    private let store = EKEventStore()

    func requestAccess() {
        Task { @MainActor in
            do {
                let granted = try await store.requestFullAccessToEvents()
                if granted { await fetch() }
            } catch {
                self.error = error.localizedDescription
            }
        }
    }

    @MainActor
    func fetch() async {
        let now = Date()
        let end = Calendar.current.date(byAdding: .month, value: 3, to: now)!
        let pred = store.predicateForEvents(withStart: now, end: end, calendars: nil)
        let raw = store.events(matching: pred)
        events = raw.map { FuseEventMac.from(ekEvent: $0) }
    }
}

@Observable
final class CustomSourceServiceMac {
    var events: [FuseEventMac] = []
    init() { build() }

    private func build() {
        var result: [FuseEventMac] = []
        if let payday = nextPayday() {
            result.append(FuseEventMac(id: "tally-payday", title: "Payday", date: payday,
                                       category: "payday", source: "tally", isAllDay: false))
        }
        events = result
    }

    private func nextPayday() -> Date? {
        let cal = Calendar.current
        let now = Date()
        for offset in 0...1 {
            guard let base = cal.date(byAdding: .month, value: offset, to: now),
                  let range = cal.range(of: .day, in: .month, for: base),
                  let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: base)),
                  let lastDay = cal.date(byAdding: .day, value: range.count - 1, to: monthStart)
            else { continue }
            for back in 0..<7 {
                guard let cand = cal.date(byAdding: .day, value: -back, to: lastDay) else { continue }
                if cal.component(.weekday, from: cand) == 4 {
                    var comps = cal.dateComponents([.year, .month, .day], from: cand)
                    comps.hour = 9
                    if let d = cal.date(from: comps), d > now { return d }
                    break
                }
            }
        }
        return nil
    }
}

struct FuseEventMac: Identifiable {
    let id: String
    let title: String
    let date: Date
    let category: String
    let source: String
    let isAllDay: Bool

    static func from(ekEvent: EKEvent) -> FuseEventMac {
        FuseEventMac(id: ekEvent.eventIdentifier ?? UUID().uuidString,
                     title: ekEvent.title ?? "Untitled",
                     date: ekEvent.startDate,
                     category: "ical",
                     source: ekEvent.calendar?.title ?? "Calendar",
                     isAllDay: ekEvent.isAllDay)
    }
}
