import SwiftUI
import AppKit

@Observable
final class CanvasModel {
    static let cols = 120
    static let rows = 60
    static let charW: CGFloat = 9.6
    static let charH: CGFloat = 18.0

    var grid: [[Character]] = Array(repeating: Array(repeating: " ", count: CanvasModel.cols), count: CanvasModel.rows)
    var activeTool: ComponentType? = nil
    var cursorCol: Int = 0
    var cursorRow: Int = 0
    var hoveredCol: Int = -1
    var hoveredRow: Int = -1
    var renderedText: String = ""
    private var history: [[[Character]]] = []
    private var historyIndex = -1

    init() {
        saveHistory()
        renderedText = render()
    }

    func place(_ type: ComponentType, col: Int, row: Int) {
        saveHistory()
        let lines = type.template.components(separatedBy: "\n")
        for (dy, line) in lines.enumerated() {
            for (dx, ch) in line.enumerated() {
                let r = row + dy, c = col + dx
                if r >= 0 && r < Self.rows && c >= 0 && c < Self.cols {
                    grid[r][c] = ch
                }
            }
        }
        renderedText = render()
    }

    func setChar(_ ch: Character, col: Int, row: Int) {
        guard row >= 0, row < Self.rows, col >= 0, col < Self.cols else { return }
        saveHistory()
        grid[row][col] = ch
        renderedText = render()
    }

    func eraseChar(col: Int, row: Int) {
        guard row >= 0, row < Self.rows, col >= 0, col < Self.cols else { return }
        grid[row][col] = " "
        renderedText = render()
    }

    func pixelToGrid(x: CGFloat, y: CGFloat) -> (col: Int, row: Int) {
        (col: max(0, min(Int(x / Self.charW), Self.cols - 1)),
         row: max(0, min(Int(y / Self.charH), Self.rows - 1)))
    }

    func render() -> String {
        grid.map { String($0) }.joined(separator: "\n")
    }

    func clear() {
        saveHistory()
        grid = Array(repeating: Array(repeating: " ", count: Self.cols), count: Self.rows)
        renderedText = render()
    }

    func undo() {
        guard historyIndex > 0 else { return }
        historyIndex -= 1
        grid = history[historyIndex]
        renderedText = render()
    }

    func redo() {
        guard historyIndex < history.count - 1 else { return }
        historyIndex += 1
        grid = history[historyIndex]
        renderedText = render()
    }

    var canUndo: Bool { historyIndex > 0 }
    var canRedo: Bool { historyIndex < history.count - 1 }

    @MainActor
    func exportText() {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "wireframe.txt"
        panel.allowedContentTypes = [.plainText]
        let text = self.render()
        panel.begin { result in
            if result == .OK, let url = panel.url {
                try? text.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }

    func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(render(), forType: .string)
    }

    private func saveHistory() {
        history = Array(history.prefix(historyIndex + 1))
        history.append(grid)
        if history.count > 200 {
            history.removeFirst()
        } else {
            historyIndex = history.count - 1
        }
    }
}
