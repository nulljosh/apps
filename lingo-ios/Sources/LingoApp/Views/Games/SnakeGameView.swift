import SwiftUI

struct SnakeGameView: View {
    private let gridSize = 15
    @State private var snake: [(Int, Int)] = [(7, 7)]
    @State private var dir: (Int, Int) = (1, 0)
    @State private var food: (Int, Int) = (10, 10)
    @State private var score = 0
    @State private var running = false
    @State private var dead = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 12) {
            Text(dead ? "Game Over -- Score: \(score)" : "Score: \(score)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(dead ? .red : .secondary)

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let cell = size / CGFloat(gridSize)
                Canvas { ctx, _ in
                    // Background
                    ctx.fill(Path(CGRect(origin: .zero, size: CGSize(width: size, height: size))), with: .color(Color(.systemGray6)))
                    // Food
                    let foodRect = CGRect(x: CGFloat(food.0) * cell + 2, y: CGFloat(food.1) * cell + 2, width: cell - 4, height: cell - 4)
                    ctx.fill(Path(ellipseIn: foodRect), with: .color(.orange))
                    // Snake
                    for (i, seg) in snake.enumerated() {
                        let r = CGRect(x: CGFloat(seg.0) * cell + 1, y: CGFloat(seg.1) * cell + 1, width: cell - 2, height: cell - 2)
                        ctx.fill(Path(r), with: .color(i == 0 ? .green : .green.opacity(0.7)))
                    }
                }
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.secondary.opacity(0.3), lineWidth: 2))
                .gesture(DragGesture(minimumDistance: 15).onEnded { val in
                    if !running && !dead { startRunning() }
                    let h = val.translation.width, v = val.translation.height
                    var nd: (Int, Int)
                    if abs(h) > abs(v) { nd = h > 0 ? (1, 0) : (-1, 0) }
                    else { nd = v > 0 ? (0, 1) : (0, -1) }
                    if dir.0 != -nd.0 || dir.1 != -nd.1 { dir = nd }
                })
            }
            .aspectRatio(1, contentMode: .fit)

            // D-pad
            VStack(spacing: 4) {
                dpadButton("\u{25B2}", dx: 0, dy: -1)
                HStack(spacing: 24) {
                    dpadButton("\u{25C0}", dx: -1, dy: 0)
                    dpadButton("\u{25B6}", dx: 1, dy: 0)
                }
                dpadButton("\u{25BC}", dx: 0, dy: 1)
            }

            Button(dead ? "New Game" : (running ? "Running" : "Tap to Start")) {
                if dead { resetGame() } else if !running { startRunning() }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear { placeFood() }
        .onDisappear { timer?.invalidate() }
    }

    private func dpadButton(_ label: String, dx: Int, dy: Int) -> some View {
        Button(label) {
            if !running && !dead { startRunning() }
            if dir.0 != -dx || dir.1 != -dy { dir = (dx, dy) }
        }
        .font(.title2)
        .frame(width: 52, height: 52)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    private func resetGame() {
        timer?.invalidate()
        snake = [(7, 7)]; dir = (1, 0); score = 0; dead = false; running = false
        placeFood()
    }

    private func startRunning() {
        running = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in tick() }
    }

    private func placeFood() {
        let occupied = Set(snake.map { "\($0.0),\($0.1)" })
        var empty: [(Int, Int)] = []
        for x in 0..<gridSize { for y in 0..<gridSize { if !occupied.contains("\(x),\(y)") { empty.append((x, y)) } } }
        if let f = empty.randomElement() { food = f }
    }

    private func tick() {
        guard running, !dead else { return }
        let head = (snake[0].0 + dir.0, snake[0].1 + dir.1)
        if head.0 < 0 || head.0 >= gridSize || head.1 < 0 || head.1 >= gridSize || snake.contains(where: { $0.0 == head.0 && $0.1 == head.1 }) {
            dead = true; running = false; timer?.invalidate(); return
        }
        snake.insert(head, at: 0)
        if head.0 == food.0 && head.1 == food.1 { score += 10; placeFood() }
        else { snake.removeLast() }
    }
}
