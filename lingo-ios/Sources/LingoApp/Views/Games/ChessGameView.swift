import SwiftUI

struct ChessGameView: View {
    @State private var board: [[Character]] = ChessGameView.initialBoard
    @State private var turn: PieceColor = .white
    @State private var selected: (Int, Int)? = nil
    @State private var validMoves: [(Int, Int)] = []
    @State private var gameOver = false
    @State private var winner: PieceColor? = nil

    enum PieceColor { case white, black }

    static let initialBoard: [[Character]] = [
        ["r","n","b","q","k","b","n","r"],
        ["p","p","p","p","p","p","p","p"],
        [" "," "," "," "," "," "," "," "],
        [" "," "," "," "," "," "," "," "],
        [" "," "," "," "," "," "," "," "],
        [" "," "," "," "," "," "," "," "],
        ["P","P","P","P","P","P","P","P"],
        ["R","N","B","Q","K","B","N","R"]
    ]

    static let pieceSymbols: [Character: String] = [
        "K": "\u{2654}", "Q": "\u{2655}", "R": "\u{2656}", "B": "\u{2657}", "N": "\u{2658}", "P": "\u{2659}",
        "k": "\u{265A}", "q": "\u{265B}", "r": "\u{265C}", "b": "\u{265D}", "n": "\u{265E}", "p": "\u{265F}"
    ]

    @State private var statusText = "White to move"

    var body: some View {
        VStack(spacing: 12) {
            Text(statusText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(gameOver ? Theme.success : .secondary)

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let cell = size / 8
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(cell), spacing: 0), count: 8), spacing: 0) {
                    ForEach(0..<64, id: \.self) { idx in
                        let r = idx / 8, c = idx % 8
                        let isDark = (r + c) % 2 == 1
                        let isSelected = selected?.0 == r && selected?.1 == c
                        let isValid = validMoves.contains { $0.0 == r && $0.1 == c }
                        ZStack {
                            Rectangle()
                                .fill(isSelected ? Color.primary.opacity(0.2) : isDark ? Color(hex: "#c0c0c0") : Color(hex: "#f0f0f0"))
                            if isValid {
                                Circle()
                                    .fill(.black.opacity(0.25))
                                    .frame(width: cell * 0.3, height: cell * 0.3)
                            }
                            if board[r][c] != " " {
                                Text(Self.pieceSymbols[board[r][c]] ?? "")
                                    .font(.system(size: cell * 0.7))
                            }
                        }
                        .frame(width: cell, height: cell)
                        .onTapGesture { handleTap(r, c) }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.secondary.opacity(0.3), lineWidth: 2))
            }
            .aspectRatio(1, contentMode: .fit)

            Button("New Game") {
                board = Self.initialBoard
                turn = .white; selected = nil; validMoves = []; gameOver = false; winner = nil; statusText = "White to move"
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    private func isWhite(_ p: Character) -> Bool { p != " " && p.isUppercase }
    private func isBlack(_ p: Character) -> Bool { p != " " && p.isLowercase }
    private func isOwn(_ p: Character) -> Bool { turn == .white ? isWhite(p) : isBlack(p) }

    private func findKing(_ b: [[Character]], _ white: Bool) -> (Int, Int)? {
        let k: Character = white ? "K" : "k"
        for r in 0..<8 { for c in 0..<8 { if b[r][c] == k { return (r, c) } } }
        return nil
    }

    private func isAttacked(_ b: [[Character]], _ tr: Int, _ tc: Int, byWhite: Bool) -> Bool {
        for r in 0..<8 { for c in 0..<8 {
            let p = b[r][c]
            if p == " " || (byWhite ? !isWhite(p) : !isBlack(p)) { continue }
            if getMoves(r, c, b).contains(where: { $0.0 == tr && $0.1 == tc }) { return true }
        }}
        return false
    }

    private func inCheck(_ b: [[Character]], whiteKing: Bool) -> Bool {
        guard let k = findKing(b, whiteKing) else { return true }
        return isAttacked(b, k.0, k.1, byWhite: !whiteKing)
    }

    private func legalMoves(_ r: Int, _ c: Int) -> [(Int, Int)] {
        let whiteKing = turn == .white
        return getMoves(r, c, board).filter { (tr, tc) in
            var copy = board
            copy[tr][tc] = copy[r][c]; copy[r][c] = " "
            return !inCheck(copy, whiteKing: whiteKing)
        }
    }

    private func hasAnyLegal(_ t: PieceColor) -> Bool {
        for r in 0..<8 { for c in 0..<8 {
            let p = board[r][c]
            if p == " " || (t == .white ? !isWhite(p) : !isBlack(p)) { continue }
            // temporarily swap turn for legalMoves
            let savedTurn = turn; turn = t
            let moves = legalMoves(r, c)
            turn = savedTurn
            if !moves.isEmpty { return true }
        }}
        return false
    }

    private func getMoves(_ r: Int, _ c: Int, _ b: [[Character]]) -> [(Int, Int)] {
        let p = b[r][c]
        let white = isWhite(p)
        var moves: [(Int, Int)] = []
        func tryAdd(_ nr: Int, _ nc: Int) -> Bool {
            guard (0..<8).contains(nr), (0..<8).contains(nc) else { return false }
            if b[nr][nc] == " " { moves.append((nr, nc)); return true }
            if (white && isBlack(b[nr][nc])) || (!white && isWhite(b[nr][nc])) { moves.append((nr, nc)) }
            return false
        }
        func slide(_ dirs: [(Int,Int)]) {
            for (dr,dc) in dirs {
                for i in 1..<8 {
                    let nr = r+dr*i, nc = c+dc*i
                    guard (0..<8).contains(nr), (0..<8).contains(nc) else { break }
                    if b[nr][nc] == " " { moves.append((nr, nc)); continue }
                    if (white && isBlack(b[nr][nc])) || (!white && isWhite(b[nr][nc])) { moves.append((nr, nc)) }
                    break
                }
            }
        }
        switch p.lowercased() {
        case "p":
            let dir = white ? -1 : 1; let start = white ? 6 : 1
            if (0..<8).contains(r+dir) && b[r+dir][c] == " " {
                moves.append((r+dir, c))
                if r == start && b[r+dir*2][c] == " " { moves.append((r+dir*2, c)) }
            }
            for dc in [-1, 1] {
                let nr = r+dir, nc = c+dc
                if (0..<8).contains(nr) && (0..<8).contains(nc) && ((white && isBlack(b[nr][nc])) || (!white && isWhite(b[nr][nc]))) {
                    moves.append((nr, nc))
                }
            }
        case "r": slide([(0,1),(0,-1),(1,0),(-1,0)])
        case "b": slide([(1,1),(1,-1),(-1,1),(-1,-1)])
        case "q": slide([(0,1),(0,-1),(1,0),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)])
        case "n": for (dr,dc) in [(-2,-1),(-2,1),(-1,-2),(-1,2),(1,-2),(1,2),(2,-1),(2,1)] { _ = tryAdd(r+dr, c+dc) }
        case "k": for dr in -1...1 { for dc in -1...1 { if dr != 0 || dc != 0 { _ = tryAdd(r+dr, c+dc) } } }
        default: break
        }
        return moves
    }

    private func handleTap(_ r: Int, _ c: Int) {
        guard !gameOver else { return }
        if let sel = selected {
            if validMoves.contains(where: { $0.0 == r && $0.1 == c }) {
                board[r][c] = board[sel.0][sel.1]
                board[sel.0][sel.1] = " "
                if board[r][c] == "P" && r == 0 { board[r][c] = "Q" }
                if board[r][c] == "p" && r == 7 { board[r][c] = "q" }
                turn = turn == .white ? .black : .white

                let check = inCheck(board, whiteKing: turn == .white)
                let canMove = hasAnyLegal(turn)
                if !canMove {
                    gameOver = true
                    winner = turn == .white ? .black : .white
                    statusText = check ? "Checkmate -- \(winner == .white ? "White" : "Black") wins!" : "Stalemate -- Draw"
                } else if check {
                    statusText = "\(turn == .white ? "White" : "Black") to move -- Check!"
                } else {
                    statusText = "\(turn == .white ? "White" : "Black") to move"
                }
                selected = nil; validMoves = []
            } else if isOwn(board[r][c]) {
                selected = (r, c); validMoves = legalMoves(r, c)
            } else { selected = nil; validMoves = [] }
        } else if isOwn(board[r][c]) {
            selected = (r, c); validMoves = legalMoves(r, c)
        }
    }
}
