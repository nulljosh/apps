import SwiftUI

@main
struct ChartersApp: App {
    @StateObject private var auth = AuthManager()
    @StateObject private var cases = CaseStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)
                .environmentObject(cases)
        }
    }
}
