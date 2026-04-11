import SwiftUI
import EventKit

@main
struct FuseApp: App {
    @State private var calendarService = CalendarService()
    @State private var customSourceService = CustomSourceService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(calendarService)
                .environment(customSourceService)
                .onAppear {
                    calendarService.requestAccess()
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "timeline.selection")
                }
            UpcomingListView()
                .tabItem {
                    Label("Upcoming", systemImage: "list.bullet.below.rectangle")
                }
        }
        .preferredColorScheme(.dark)
    }
}
