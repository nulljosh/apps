import SwiftUI

@main
struct CompassApp: App {
    @StateObject private var session = CompassSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
