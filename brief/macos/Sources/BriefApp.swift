import SwiftUI

private func nextTheme(_ t: String) -> String {
    switch t { case "dark": return "light"; case "light": return "auto"; default: return "dark" }
}
private func themeMenuLabel(_ t: String) -> String {
    switch t { case "dark": return "Switch to Light"; case "light": return "Switch to Auto"; default: return "Switch to Dark" }
}

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
            .preferredColorScheme(store.theme == "dark" ? .dark : store.theme == "light" ? .light : nil)
            .onOpenURL { url in
                Task { await store.handleURL(url) }
            }
            .task { await store.checkSession() }
        }
        .defaultSize(width: 1100, height: 750)
        .commands {
            CommandGroup(after: .appSettings) {
                Button(themeMenuLabel(store.theme)) {
                    store.theme = nextTheme(store.theme)
                }
                .keyboardShortcut("t", modifiers: .command)
            }
        }
    }
}
