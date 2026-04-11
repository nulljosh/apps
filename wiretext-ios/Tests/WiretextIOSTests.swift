import Testing
@testable import WiretextIOS

@Suite("iOS Canvas") struct WiretextIOSTests {
    @Test func placeStamps() { let m = CanvasModel(); m.place(.button, col: 0, row: 0); #expect(m.grid[0][0] != " ") }
    @Test func clearEmpties() { let m = CanvasModel(); m.place(.card, col: 0, row: 0); m.clear(); #expect(m.grid.allSatisfy { $0.allSatisfy { $0 == " " } }) }
}
