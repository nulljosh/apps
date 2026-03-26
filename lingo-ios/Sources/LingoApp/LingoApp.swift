import SwiftUI

@main
struct LingoApp: App {
    @State private var progressManager = ProgressManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progressManager)
        }
    }
}
