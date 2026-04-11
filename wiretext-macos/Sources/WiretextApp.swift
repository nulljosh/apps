import SwiftUI

@main
struct WiretextApp: App {
    @State private var canvas = CanvasModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(canvas)
        }
        .defaultSize(width: 1100, height: 700)
        .commands {
            CommandMenu("Edit") {
                Button("Undo") { canvas.undo() }.keyboardShortcut("z", modifiers: .command)
                Button("Redo") { canvas.redo() }.keyboardShortcut("z", modifiers: [.command, .shift])
                Divider()
                Button("Clear") { canvas.clear() }
            }
            CommandMenu("Export") {
                Button("Export as Text...") { canvas.exportText() }.keyboardShortcut("e", modifiers: .command)
                Button("Copy to Clipboard") { canvas.copyToClipboard() }.keyboardShortcut("c", modifiers: [.command, .shift])
            }
        }
    }
}
