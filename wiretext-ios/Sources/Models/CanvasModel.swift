import SwiftUI

@Observable
final class CanvasModel {
    static let cols = 80
    static let rows = 50
    static let charW: CGFloat = 8.0
    static let charH: CGFloat = 19.0

    var grid: [[Character]] = Array(repeating: Array(repeating: " ", count: CanvasModel.cols), count: CanvasModel.rows)
    var activeTool: ComponentType? = nil
    var cursorRow: Int = 0
    var cursorCol: Int = 0
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
        saveHistory()
        grid[row][col] = " "
        renderedText = render()
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

    private func saveHistory() {
        history = Array(history.prefix(historyIndex + 1))
        history.append(grid)
        if history.count > 100 {
            history.removeFirst()
        } else {
            historyIndex = history.count - 1
        }
    }
}
