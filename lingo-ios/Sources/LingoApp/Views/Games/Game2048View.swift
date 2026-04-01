import SwiftUI

struct Game2048View: View {
    @State private var grid = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    @State private var score = 0
    @State private var gameOver = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Score: \(score)\(gameOver ? " -- Game Over" : "")")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(gameOver ? Theme.error : .secondary)

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let gap: CGFloat = 6
                let cell = (size - gap * 5) / 4
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray4))
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(cell), spacing: gap), count: 4), spacing: gap) {
                        ForEach(0..<16, id: \.self) { idx in
                            let val = grid[idx / 4][idx % 4]
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(tileColor(val))
                                if val > 0 {
                                    Text("\(val)")
                                        .font(.system(size: cell * 0.35, weight: .heavy, design: .rounded))
                                        .foregroundStyle(val <= 4 ? Color(.systemGray) : .white)
                                        .minimumScaleFactor(0.5)
                                }
                            }
                            .frame(width: cell, height: cell)
                        }
                    }
                    .padding(gap)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .gesture(DragGesture(minimumDistance: 30).onEnded { val in
                let h = val.translation.width, v = val.translation.height
                if abs(h) > abs(v) { move(h > 0 ? .right : .left) }
                else { move(v > 0 ? .down : .up) }
            })

            Button("New Game") { resetGame() }
                .buttonStyle(.bordered)
        }
        .padding()
        .onAppear { resetGame() }
    }

    enum Dir { case up, down, left, right }

    private func resetGame() {
        grid = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0; gameOver = false
        addTile(); addTile()
    }

    private func addTile() {
        var empty: [(Int,Int)] = []
        for r in 0..<4 { for c in 0..<4 { if grid[r][c] == 0 { empty.append((r,c)) } } }
        guard let pos = empty.randomElement() else { return }
        grid[pos.0][pos.1] = Double.random(in: 0..<1) < 0.9 ? 2 : 4
    }

    private func slide(_ row: [Int]) -> [Int] {
        var arr = row.filter { $0 != 0 }
        var i = 0
        while i < arr.count - 1 {
            if arr[i] == arr[i+1] { arr[i] *= 2; score += arr[i]; arr.remove(at: i+1) }
            i += 1
        }
        while arr.count < 4 { arr.append(0) }
        return arr
    }

    private func move(_ dir: Dir) {
        guard !gameOver else { return }
        let prev = grid
        switch dir {
        case .left: for r in 0..<4 { grid[r] = slide(grid[r]) }
        case .right: for r in 0..<4 { grid[r] = slide(grid[r].reversed()).reversed() }
        case .up:
            for c in 0..<4 {
                let col = slide([grid[0][c], grid[1][c], grid[2][c], grid[3][c]])
                for r in 0..<4 { grid[r][c] = col[r] }
            }
        case .down:
            for c in 0..<4 {
                let col = slide([grid[3][c], grid[2][c], grid[1][c], grid[0][c]])
                for r in 0..<4 { grid[3-r][c] = col[r] }
            }
        }
        if grid != prev { addTile(); if !canMove() { gameOver = true } }
    }

    private func canMove() -> Bool {
        for r in 0..<4 { for c in 0..<4 {
            if grid[r][c] == 0 { return true }
            if c < 3 && grid[r][c] == grid[r][c+1] { return true }
            if r < 3 && grid[r][c] == grid[r+1][c] { return true }
        }}
        return false
    }

    private func tileColor(_ v: Int) -> Color {
        switch v {
        case 0: return Color(hex: "#e8e8e8")
        case 2: return Color(hex: "#d4d4d8")
        case 4: return Color(hex: "#c0c0c8")
        case 8: return Color(hex: "#a8a8b0")
        case 16: return Color(hex: "#909098")
        case 32: return Color(hex: "#787880")
        case 64: return Color(hex: "#606068")
        case 128: return Color(hex: "#505058")
        case 256: return Color(hex: "#404048")
        case 512: return Color(hex: "#303038")
        case 1024: return Color(hex: "#202028")
        default: return Color(hex: "#18181b")
        }
    }
}
