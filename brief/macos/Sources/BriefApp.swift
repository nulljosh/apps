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
        .defaultSize(width: 1100, height: 750)
        .commands {
            CommandGroup(after: .appSettings) {
                Button(store.theme == "dark" ? "Switch to Light" : "Switch to Dark") {
                    store.theme = store.theme == "dark" ? "light" : "dark"
                }
                .keyboardShortcut("t", modifiers: .command)
            }
        }
    }
}
