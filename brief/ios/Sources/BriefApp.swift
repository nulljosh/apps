import SwiftUI

@main
struct BriefApp: App {
    @State private var store = Store()

    var body: some Scene {
        WindowGroup {
            Group {
                if store.needsSignIn {
                    SignInView()
                } else {
                    ContentView()
                }
            }
            .environment(store)
            .preferredColorScheme(store.theme == "dark" ? .dark : .light)
            .onOpenURL { url in
                Task { await store.handleURL(url) }
            }
        }
    }
}
