import SwiftUI

struct CountdownView: View {
    let event: FuseEvent
    let large: Bool

    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var remaining: TimeInterval { max(0, event.date.timeIntervalSince(now)) }

    private var days: Int    { Int(remaining) / 86400 }
    private var hours: Int   { (Int(remaining) % 86400) / 3600 }
    private var minutes: Int { (Int(remaining) % 3600) / 60 }
    private var seconds: Int { Int(remaining) % 60 }

    private var urgencyColor: Color {
        let h = remaining / 3600
        if h <= 24 { return .red }
        if h <= 72 { return Color.orange }
        return Color.blue
    }

    private var digitSize: CGFloat { large ? 52 : 32 }
    private var unitSize: CGFloat  { large ? 9 : 8 }

    var body: some View {
        VStack(alignment: large ? .center : .leading, spacing: 4) {
            HStack(alignment: .bottom, spacing: 2) {
                if days > 0 {
                    unitBlock(String(format: "%02d", days), label: days == 1 ? "day" : "days")
                    colonSep
                }
                unitBlock(String(format: "%02d", hours), label: "hr")
                colonSep
                unitBlock(String(format: "%02d", minutes), label: "min")
                colonSep
                unitBlock(String(format: "%02d", seconds), label: "sec")
            }
        }
        .onReceive(timer) { now = $0 }
    }

    private var colonSep: some View {
        Text(":")
            .font(.system(size: digitSize, weight: .bold, design: .monospaced))
            .foregroundStyle(urgencyColor)
            .opacity(seconds % 2 == 0 ? 1 : 0.3)
            .animation(.easeInOut(duration: 0.3), value: seconds)
            .padding(.bottom, large ? 14 : 8)
    }

    private func unitBlock(_ value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: digitSize, weight: .bold, design: .monospaced))
                .foregroundStyle(urgencyColor)
                .contentTransition(.numericText())
                .animation(.default, value: value)
            Text(label)
                .font(.system(size: unitSize, weight: .medium))
                .foregroundStyle(.tertiary)
                .textCase(.uppercase)
                .tracking(1.5)
        }
    }
}
