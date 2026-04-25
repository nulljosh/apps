import SwiftUI

@main
struct WiretextApp: App {
    @State private var canvas = CanvasModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(canvas)
                .preferredColorScheme(.dark)
        }
    }
}
