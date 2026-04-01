import SwiftUI

@main
struct LingoApp: App {
    @State private var progressManager = ProgressManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progressManager)
                .frame(minWidth: 800, minHeight: 600)
        }
        .defaultSize(width: 960, height: 680)
    }
}
