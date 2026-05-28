import SwiftUI
import SwiftData

@main
struct BCGDashboardMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 900, minHeight: 600)
        }
        .modelContainer(for: [Part.self, Job.self])
        .commands {
            CommandGroup(after: .sidebar) {
                Button("Search Inventory") {}
                    .keyboardShortcut("k", modifiers: .command)
            }
        }
    }
}
