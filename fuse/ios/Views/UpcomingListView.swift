import SwiftUI

struct UpcomingListView: View {
    @Environment(CalendarService.self) private var cal
    @Environment(CustomSourceService.self) private var custom

    private var events: [FuseEvent] {
        (cal.events + custom.events)
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 6) {
                    ForEach(Array(events.enumerated()), id: \.element.id) { i, event in
                        row(rank: i + 1, event: event)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color.black)
            .navigationTitle("upcoming")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func row(rank: Int, event: FuseEvent) -> some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.quaternary)
                .frame(width: 20, alignment: .trailing)

            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                Text(event.isAllDay
                     ? event.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
                     : event.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute()))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(shortCountdown(event.date))
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundStyle(urgencyColor(event.date))
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.07), lineWidth: 1))
    }

    private func shortCountdown(_ date: Date) -> String {
        let s = max(0, date.timeIntervalSinceNow)
        let d = Int(s) / 86400
        let h = (Int(s) % 86400) / 3600
        let m = (Int(s) % 3600) / 60
        if d > 0 { return "\(d)d \(h)h" }
        if h > 0 { return "\(h)h \(String(format: "%02d", m))m" }
        return "\(String(format: "%02d", m))m"
    }

    private func urgencyColor(_ date: Date) -> Color {
        let h = date.timeIntervalSinceNow / 3600
        if h <= 24 { return .red }
        if h <= 72 { return .orange }
        return .blue
    }
}
