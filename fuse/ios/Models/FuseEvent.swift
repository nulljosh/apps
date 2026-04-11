import Foundation
import EventKit

enum EventCategory: String, Codable {
    case ical, payday, custom
}

struct FuseEvent: Identifiable, Equatable {
    let id: String
    let title: String
    let date: Date
    let category: EventCategory
    let source: String
    let isAllDay: Bool
    let calendarColor: String?

    var msUntil: TimeInterval { date.timeIntervalSinceNow * 1000 }
    var isImminent: Bool { date.timeIntervalSinceNow < 86400 }

    static func from(ekEvent: EKEvent) -> FuseEvent {
        FuseEvent(
            id: ekEvent.eventIdentifier ?? UUID().uuidString,
            title: ekEvent.title ?? "Untitled",
            date: ekEvent.startDate,
            category: .ical,
            source: ekEvent.calendar?.title ?? "Calendar",
            isAllDay: ekEvent.isAllDay,
            calendarColor: nil
        )
    }
}
