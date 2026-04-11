import SwiftUI

@main
struct WiretextApp: App {
    @State private var canvas = CanvasModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(canvas)
        }
        .defaultSize(width: 1200, height: 750)
        .commands {
            CommandMenu("Edit") {
                Button("Undo") { canvas.undo() }
                    .keyboardShortcut("z", modifiers: .command)
                    .disabled(!canvas.canUndo)
                Button("Redo") { canvas.redo() }
                    .keyboardShortcut("z", modifiers: [.command, .shift])
                    .disabled(!canvas.canRedo)
                Divider()
                Button("Clear Canvas") { canvas.clear() }
            }
            CommandMenu("Export") {
                Button("Export as Text...") { canvas.exportText() }
                    .keyboardShortcut("e", modifiers: .command)
                Button("Copy to Clipboard") { canvas.copyToClipboard() }
                    .keyboardShortcut("c", modifiers: [.command, .shift])
            }
        }
    }
}
