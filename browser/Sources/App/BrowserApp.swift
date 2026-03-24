import SwiftUI

@main
struct BrowserApp: App {
    @NSApplicationDelegateAdaptor(BrowserAppDelegate.self) var appDelegate
    @State private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            BrowserWindow()
                .environment(appState)
                .frame(minWidth: 1000, minHeight: 700)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Tab") {
                    appState.addTab()
                }
                .keyboardShortcut("t", modifiers: .command)

                Button("New Private Tab") {
                    appState.addTab(isPrivate: true)
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])

                Divider()

                Button("Reopen Closed Tab") {
                    appState.reopenClosedTab()
                }
                .keyboardShortcut("t", modifiers: [.command, .shift])
            }

            CommandGroup(after: .appSettings) {
                Button("About Browser") {
                    NSApp.orderFrontStandardAboutPanel(options: [
                        NSApplication.AboutPanelOptionKey.applicationName: "Browser",
                        NSApplication.AboutPanelOptionKey.applicationVersion: "2.0.0",
                        NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "A native macOS web browser built with WebKit and SwiftUI.\n\nBuilt by Joshua Trommel\nMIT License 2026",
                            attributes: [.font: NSFont.systemFont(ofSize: 11)]
                        )
                    ])
                }
            }
        }

        Settings {
            SettingsView()
                .environment(appState)
        }
    }
}

final class BrowserAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Storage.clearCleanShutdownFlag()

        // Check for crash recovery
        if !Storage.wasCleanShutdown(), let recovery = Storage.loadCrashRecoveryState() {
            let timeSinceCrash = Date().timeIntervalSince(recovery.timestamp)
            // Only offer recovery if the data is less than 1 hour old
            if timeSinceCrash < 3600 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.offerCrashRecovery(recovery)
                }
            }
        }
        Storage.clearCrashRecoveryState()
    }

    func applicationWillTerminate(_ notification: Notification) {
        Task { @MainActor in
            AppState.shared.handleCleanShutdown()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    private func offerCrashRecovery(_ recovery: CrashRecoveryData) {
        let alert = NSAlert()
        alert.messageText = "Restore Previous Session?"
        alert.informativeText = "Browser quit unexpectedly. Would you like to restore your \(recovery.tabs.count) open tab(s)?"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Restore")
        alert.addButton(withTitle: "Start Fresh")

        if alert.runModal() == .alertFirstButtonReturn {
            Task { @MainActor in
                let state = AppState.shared
                for tabData in recovery.tabs {
                    if let url = URL(string: tabData.urlString) {
                        state.addTab(url: url)
                    }
                }
            }
        }
    }
}
