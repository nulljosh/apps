import SwiftUI

@Observable
final class CanvasModel {
    static let cols = 80
    static let rows = 50

    var grid: [[Character]] = Array(repeating: Array(repeating: " ", count: CanvasModel.cols), count: CanvasModel.rows)
    var activeTool: ComponentType? = nil
    var renderedText: String = ""
    private var history: [[[Character]]] = []
    private var historyIndex = -1

    init() { saveHistory(); renderedText = render() }

    func place(_ type: ComponentType, col: Int, row: Int) {
        saveHistory()
        for (dy, line) in type.template.components(separatedBy: "\n").enumerated() {
            for (dx, ch) in line.enumerated() {
                let r = row + dy, c = col + dx
                if r >= 0 && r < Self.rows && c >= 0 && c < Self.cols { grid[r][c] = ch }
            }
        }
        renderedText = render()
    }

    func render() -> String { grid.map { String($0) }.joined(separator: "\n") }
    func clear() { saveHistory(); grid = Array(repeating: Array(repeating: " ", count: Self.cols), count: Self.rows); renderedText = render() }
    func undo() { guard historyIndex > 0 else { return }; historyIndex -= 1; grid = history[historyIndex]; renderedText = render() }
    func redo() { guard historyIndex < history.count - 1 else { return }; historyIndex += 1; grid = history[historyIndex]; renderedText = render() }
    private func saveHistory() { history = Array(history.prefix(historyIndex + 1)); history.append(grid); historyIndex = history.count - 1 }
}
