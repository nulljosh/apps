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
                .tint(.primary)
        }
    }
}
