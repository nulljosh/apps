import SwiftUI

// Watch shows next event countdown. Events passed via App Storage / shared defaults.
struct WatchTimelineView: View {
    // On real device, events come from WatchConnectivity or shared UserDefaults.
    // Placeholder: shows payday countdown computed locally.
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var nextPayday: Date { computeNextPayday() }
    private var remaining: TimeInterval { max(0, nextPayday.timeIntervalSince(now)) }

    private var days: Int    { Int(remaining) / 86400 }
    private var hours: Int   { (Int(remaining) % 86400) / 3600 }
    private var minutes: Int { (Int(remaining) % 3600) / 60 }
    private var seconds: Int { Int(remaining) % 60 }

    var body: some View {
        VStack(spacing: 4) {
            Text("payday")
                .font(.system(size: 10, weight: .semibold))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)

            HStack(alignment: .bottom, spacing: 1) {
                if days > 0 {
                    Text("\(days)d")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundStyle(.green)
                }
                Text(String(format: "%02d:%02d", hours, minutes))
                    .font(.system(size: days > 0 ? 22 : 32, weight: .bold, design: .monospaced))
                    .foregroundStyle(.green)
                    .contentTransition(.numericText())
            }

            Text(nextPayday.formatted(.dateTime.month(.abbreviated).day()))
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
        }
        .onReceive(timer) { now = $0 }
    }

    private func computeNextPayday() -> Date {
        let cal = Calendar.current
        for offset in 0...1 {
            guard let base = cal.date(byAdding: .month, value: offset, to: Date()),
                  let range = cal.range(of: .day, in: .month, for: base),
                  let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: base)),
                  let lastDay = cal.date(byAdding: .day, value: range.count - 1, to: monthStart)
            else { continue }
            for back in 0..<7 {
                guard let cand = cal.date(byAdding: .day, value: -back, to: lastDay) else { continue }
                if cal.component(.weekday, from: cand) == 4 {
                    var comps = cal.dateComponents([.year, .month, .day], from: cand)
                    comps.hour = 9
                    if let d = cal.date(from: comps), d > Date() { return d }
                    break
                }
            }
        }
        return Date()
    }
}
