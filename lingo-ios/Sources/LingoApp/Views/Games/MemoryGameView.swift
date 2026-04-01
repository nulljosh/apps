import SwiftUI

struct MemoryGameView: View {
    @State private var cards: [String] = []
    @State private var flipped: Set<Int> = []
    @State private var matched: Set<Int> = []
    @State private var moves = 0
    @State private var locked = false

    private let symbols = ["\u{2660}", "\u{2665}", "\u{2666}", "\u{2663}", "\u{2605}", "\u{263A}", "\u{2602}", "\u{2708}"]

    var body: some View {
        VStack(spacing: 16) {
            Text(matched.count == 16 ? "Complete in \(moves) moves!" : "Moves: \(moves) | Matched: \(matched.count / 2)/8")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(0..<16, id: \.self) { i in
                    let isShown = flipped.contains(i) || matched.contains(i)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(matched.contains(i) ? Theme.success.opacity(0.15) : isShown ? Color.primary.opacity(0.08) : Theme.adaptiveCardBg)
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(matched.contains(i) ? Theme.success : isShown ? Color.primary : Theme.adaptiveBorder, lineWidth: 2)
                        if isShown && i < cards.count {
                            Text(cards[i])
                                .font(.system(size: 32))
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .opacity(matched.contains(i) ? 0.6 : 1)
                    .onTapGesture { handleTap(i) }
                }
            }
            .padding(.horizontal)

            Button("New Game") { resetGame() }
                .buttonStyle(.bordered)
        }
        .padding()
        .onAppear { resetGame() }
    }

    private func resetGame() {
        cards = (symbols + symbols).shuffled()
        flipped = []; matched = []; moves = 0; locked = false
    }

    private func handleTap(_ i: Int) {
        guard !locked, !flipped.contains(i), !matched.contains(i) else { return }
        flipped.insert(i)
        if flipped.count == 2 {
            moves += 1; locked = true
            let indices = Array(flipped)
            if cards[indices[0]] == cards[indices[1]] {
                matched.formUnion(flipped); flipped = []; locked = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    flipped = []; locked = false
                }
            }
        }
    }
}
