import Testing
@testable import WiretextIOS

@Suite("iOS Canvas") struct WiretextIOSTests {
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

    @Test func boundsClamp() {
        let m = CanvasModel()
        // placing off-canvas should not crash
        m.place(.table, col: CanvasModel.cols - 1, row: CanvasModel.rows - 1)
        #expect(m.grid[CanvasModel.rows - 1][CanvasModel.cols - 1] != nil as Character?)
    }

    @Test func renderLineCount() {
        let m = CanvasModel()
        let lines = m.render().components(separatedBy: "\n")
        #expect(lines.count == CanvasModel.rows)
    }
}
