import SwiftUI

struct MinesweeperView: View {
    private let rows = 9, cols = 9, mineCount = 10

    @State private var cells: [[Cell]] = []
    @State private var gameOver = false
    @State private var won = false
    @State private var firstClick = true

    struct Cell {
        var mine = false, revealed = false, flagged = false, adjacent = 0
    }

    var body: some View {
        VStack(spacing: 12) {
            let flags = cells.flatMap { $0 }.filter(\.flagged).count
            Text(gameOver ? (won ? "You Win!" : "Game Over") : "Mines: \(mineCount - flags)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(gameOver ? (won ? Theme.success : Theme.error) : .secondary)

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let cell = size / CGFloat(cols)
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(cell), spacing: 1), count: cols), spacing: 1) {
                    ForEach(0..<(rows * cols), id: \.self) { idx in
                        let r = idx / cols, c = idx % cols
                        cellView(r, c, cell)
                    }
                }
                .background(Color(.separator))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .aspectRatio(1, contentMode: .fit)

            Button("New Game") { resetGame() }
                .buttonStyle(.bordered)
        }
        .padding()
        .onAppear { resetGame() }
    }

    @ViewBuilder
    private func cellView(_ r: Int, _ c: Int, _ size: CGFloat) -> some View {
        let cell = cells.isEmpty ? Cell() : cells[r][c]
        ZStack {
            Rectangle().fill(cell.revealed ? Color(.systemBackground) : Color(.systemGray5))
            if cell.revealed {
                if cell.mine { Text("\u{1F4A3}").font(.system(size: size * 0.5)) }
                else if cell.adjacent > 0 {
                    Text("\(cell.adjacent)")
                        .font(.system(size: size * 0.45, weight: .bold, design: .monospaced))
                        .foregroundStyle(numColor(cell.adjacent))
                }
            } else if cell.flagged {
                Text("\u{1F6A9}").font(.system(size: size * 0.5))
            }
        }
        .frame(width: size, height: size)
        .onTapGesture { handleTap(r, c) }
        .onLongPressGesture { handleFlag(r, c) }
    }

    private func resetGame() {
        cells = Array(repeating: Array(repeating: Cell(), count: cols), count: rows)
        gameOver = false; won = false; firstClick = true
    }

    private func placeMines(_ sr: Int, _ sc: Int) {
        var placed = 0
        while placed < mineCount {
            let r = Int.random(in: 0..<rows), c = Int.random(in: 0..<cols)
            if cells[r][c].mine || (abs(r-sr) <= 1 && abs(c-sc) <= 1) { continue }
            cells[r][c].mine = true; placed += 1
        }
        for r in 0..<rows { for c in 0..<cols {
            if cells[r][c].mine { continue }
            var n = 0
            for dr in -1...1 { for dc in -1...1 {
                let nr = r+dr, nc = c+dc
                if (0..<rows).contains(nr) && (0..<cols).contains(nc) && cells[nr][nc].mine { n += 1 }
            }}
            cells[r][c].adjacent = n
        }}
    }

    private func reveal(_ r: Int, _ c: Int) {
        guard (0..<rows).contains(r), (0..<cols).contains(c), !cells[r][c].revealed, !cells[r][c].flagged else { return }
        cells[r][c].revealed = true
        if cells[r][c].adjacent == 0 && !cells[r][c].mine {
            for dr in -1...1 { for dc in -1...1 { reveal(r+dr, c+dc) } }
        }
    }

    private func handleTap(_ r: Int, _ c: Int) {
        guard !gameOver, !cells[r][c].flagged else { return }
        if firstClick { placeMines(r, c); firstClick = false }
        if cells[r][c].mine {
            gameOver = true
            for r2 in 0..<rows { for c2 in 0..<cols { if cells[r2][c2].mine { cells[r2][c2].revealed = true } } }
            return
        }
        reveal(r, c)
        let revealed = cells.flatMap { $0 }.filter(\.revealed).count
        if revealed == rows * cols - mineCount { gameOver = true; won = true }
    }

    private func handleFlag(_ r: Int, _ c: Int) {
        guard !gameOver, !cells[r][c].revealed else { return }
        cells[r][c].flagged.toggle()
    }

    private func numColor(_ n: Int) -> Color {
        switch n {
        case 1: return Color(hex: "#222222")
        case 2: return Color(hex: "#555555")
        case 3: return Color(hex: "#999999")
        case 4: return Color(hex: "#333333")
        case 5: return Color(hex: "#777777")
        default: return .primary
        }
    }
}
