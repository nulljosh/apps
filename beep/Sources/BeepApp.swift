import SwiftUI

@main
struct BeepApp: App {
    @StateObject private var session = BeepSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
