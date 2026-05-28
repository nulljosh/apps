import SwiftUI
import SwiftData

@main
struct BCGDashboardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Part.self, Job.self])
    }
}
