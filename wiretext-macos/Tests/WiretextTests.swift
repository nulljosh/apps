import Testing
@testable import Wiretext

@Suite("CanvasModel") struct WiretextTests {
    @Test func placeStamps() {
        let m = CanvasModel()
        m.place(.button, col: 0, row: 0)
        #expect(m.grid[0][0] != " ")
    }

    @Test func clearEmpties() {
        let m = CanvasModel()
        m.place(.card, col: 0, row: 0)
        m.clear()
        #expect(m.grid.allSatisfy { $0.allSatisfy { $0 == " " } })
    }

    @Test func undoReverts() {
        let m = CanvasModel()
        m.place(.button, col: 0, row: 0)
        m.undo()
        #expect(m.grid[0][0] == " ")
    }

    @Test func redoReapplies() {
        let m = CanvasModel()
        m.place(.button, col: 0, row: 0)
        m.undo()
        m.redo()
        #expect(m.grid[0][0] != " ")
    }

    @Test func canUndoFlag() {
        let m = CanvasModel()
        #expect(!m.canUndo)
        m.place(.icon, col: 0, row: 0)
        #expect(m.canUndo)
    }

    @Test func canRedoFlag() {
        let m = CanvasModel()
        m.place(.icon, col: 0, row: 0)
        #expect(!m.canRedo)
        m.undo()
        #expect(m.canRedo)
    }

    @Test func boundsClamp() {
        let m = CanvasModel()
        m.place(.table, col: CanvasModel.cols - 1, row: CanvasModel.rows - 1)
        #expect(m.grid[CanvasModel.rows - 1][CanvasModel.cols - 1] != nil as Character?)
    }

    @Test func renderLineCount() {
        let m = CanvasModel()
        let lines = m.render().components(separatedBy: "\n")
        #expect(lines.count == CanvasModel.rows)
    }

    @Test func pixelToGridOrigin() {
        let m = CanvasModel()
        let (col, row) = m.pixelToGrid(x: 0, y: 0)
        #expect(col == 0)
        #expect(row == 0)
    }

    @Test func pixelToGridClamped() {
        let m = CanvasModel()
        let (col, row) = m.pixelToGrid(x: 99999, y: 99999)
        #expect(col == CanvasModel.cols - 1)
        #expect(row == CanvasModel.rows - 1)
    }

    @Test func historyCapAt200() {
        let m = CanvasModel()
        for i in 0..<210 {
            m.place(.icon, col: i % CanvasModel.cols, row: 0)
        }
        // Should not crash and undo should still work
        m.undo()
        #expect(m.canRedo)
    }
}
