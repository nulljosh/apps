import SwiftUI

struct EventCardView: View {
    let event: FuseEvent
    let totalSpan: TimeInterval

    private var remaining: TimeInterval { max(0, event.date.timeIntervalSinceNow) }
    private var fusePct: Double { totalSpan > 0 ? remaining / totalSpan : 0 }

    private var badgeColor: Color {
        switch event.category {
        case .payday:  return .green
        case .custom:  return .blue
        case .ical:    return Color(.systemGray3)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.title)
                        .font(.system(size: 15, weight: .semibold))
                    Text(event.isAllDay
                         ? "all day · \(event.source)"
                         : "\(event.date.formatted(.dateTime.hour().minute())) · \(event.source)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(event.category.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1)
                    .textCase(.uppercase)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(badgeColor.opacity(0.15))
                    .foregroundStyle(badgeColor)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(badgeColor.opacity(0.3), lineWidth: 1))
            }

            CountdownView(event: event, large: false)

            // Fuse bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(fuseColor)
                        .frame(width: geo.size.width * fusePct, height: 3)
                        .animation(.linear(duration: 1), value: fusePct)
                }
            }
            .frame(height: 3)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }

    private var fuseColor: Color {
        let h = remaining / 3600
        if h <= 24 { return .red }
        if h <= 72 { return .orange }
        return .blue
    }
}
