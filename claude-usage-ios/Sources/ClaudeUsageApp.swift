import SwiftUI

@main
struct ClaudeUsageApp: App {
    @State private var store = UsageStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
