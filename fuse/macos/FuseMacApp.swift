import SwiftUI
import EventKit

@main
struct FuseMacApp: App {
    @State private var calendarService = CalendarServiceMac()
    @State private var customSourceService = CustomSourceServiceMac()

    var body: some Scene {
        WindowGroup {
            MacTimelineView()
                .environment(calendarService)
                .environment(customSourceService)
                .onAppear { calendarService.requestAccess() }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 420, height: 700)
    }
}
