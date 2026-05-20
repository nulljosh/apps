import SwiftUI

@main
struct BriefApp: App {
    @State private var store = Store()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if store.needsSignIn {
                    SignInView()
                } else if store.biometricLocked {
                    BiometricLockView()
                } else {
                    ContentView()
                }
            }
            .environment(store)
            .task { await store.checkSession() }
            .onChange(of: scenePhase) { _, new in
                if new == .background { store.biometricLocked = true }
            }
        }
    }
}
