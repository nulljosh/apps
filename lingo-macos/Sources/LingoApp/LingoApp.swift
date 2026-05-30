import SwiftUI

@main
struct LingoApp: App {
    @State private var progressManager = ProgressManager()
    @State private var courseStore = CourseStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progressManager)
                .environment(courseStore)
                .frame(minWidth: 800, minHeight: 600)
        }
        .defaultSize(width: 960, height: 680)
    }
}
