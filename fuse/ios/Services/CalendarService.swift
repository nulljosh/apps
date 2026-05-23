import Foundation
import EventKit
import Observation

@Observable
final class CalendarService {
    var events: [FuseEvent] = []
    var authStatus: EKAuthorizationStatus = .notDetermined
    var error: String?

    private let store = EKEventStore()

    func requestAccess() {
        Task { @MainActor in
            do {
                let granted = try await store.requestFullAccessToEvents()
                authStatus = granted ? .fullAccess : .denied
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
        events = raw.map { FuseEvent.from(ekEvent: $0) }
    }
}
