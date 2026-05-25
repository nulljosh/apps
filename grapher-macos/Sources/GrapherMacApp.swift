import SwiftUI

@main
struct GrapherMacApp: App {
    var body: some Scene {
        WindowGroup {
            MacContentView()
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Add Equation") {
                    NotificationCenter.default.post(name: .addEquation, object: nil)
                }
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }
        }
    }
}

extension Notification.Name {
    static let addEquation = Notification.Name("addEquation")
}
