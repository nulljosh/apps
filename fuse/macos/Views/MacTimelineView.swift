import SwiftUI

struct MacTimelineView: View {
    @Environment(CalendarServiceMac.self) private var cal
    @Environment(CustomSourceServiceMac.self) private var custom
    @State private var selectedTab = 0

    private var allEvents: [FuseEventMac] {
        (cal.events + custom.events)
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Label("Timeline", systemImage: "timeline.selection").tag(0)
                Label("Upcoming", systemImage: "list.bullet.below.rectangle").tag(1)
            }
            .navigationSplitViewColumnWidth(160)
        } detail: {
            if selectedTab == 0 {
                MacScrollTimeline(events: allEvents)
            } else {
                MacUpcomingList(events: allEvents)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MacScrollTimeline: View {
    let events: [FuseEventMac]
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let next = events.first {
                    VStack(spacing: 10) {
                        Text("next up")
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(2.5)
                            .textCase(.uppercase)
                            .foregroundStyle(.red)
                        Text(next.title)
                            .font(.system(size: 20, weight: .bold))
                        macCountdown(next.date)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    .padding([.horizontal, .top], 16)
                    .padding(.bottom, 8)
                }

                ForEach(events) { event in
                    HStack(spacing: 14) {
                        Rectangle()
                            .fill(event.category == "payday" ? Color.green : Color.blue)
                            .frame(width: 3)
                            .cornerRadius(2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.system(size: 14, weight: .semibold))
                            Text(event.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute()))
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(shortCD(event.date))
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundStyle(cdColor(event.date))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    Divider().padding(.leading, 35)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.black)
        .onReceive(timer) { now = $0 }
    }

    private func macCountdown(_ date: Date) -> some View {
        let s = max(0, date.timeIntervalSince(now))
        let d = Int(s) / 86400
        let h = (Int(s) % 86400) / 3600
        let m = (Int(s) % 3600) / 60
        let sec = Int(s) % 60
        let color = cdColor(date)
        return HStack(spacing: 2) {
            if d > 0 {
                Text(String(format: "%02d", d))
                    .font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
                Text("d").font(.system(size: 14)).foregroundStyle(.tertiary).padding(.bottom, 10)
            }
            Text(String(format: "%02d", h))
                .font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
            Text(":").font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
                .opacity(sec % 2 == 0 ? 1 : 0.3).animation(.easeInOut(duration: 0.3), value: sec)
                .padding(.bottom, 10)
            Text(String(format: "%02d", m))
                .font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
            Text(":").font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
                .opacity(sec % 2 == 0 ? 1 : 0.3).animation(.easeInOut(duration: 0.3), value: sec)
                .padding(.bottom, 10)
            Text(String(format: "%02d", sec))
                .font(.system(size: 42, weight: .bold, design: .monospaced)).foregroundStyle(color)
                .contentTransition(.numericText()).animation(.default, value: sec)
        }
    }

    private func shortCD(_ date: Date) -> String {
        let s = max(0, date.timeIntervalSinceNow)
        let d = Int(s) / 86400
        let h = (Int(s) % 86400) / 3600
        let m = (Int(s) % 3600) / 60
        if d > 0 { return "\(d)d \(h)h" }
        if h > 0 { return "\(h)h \(String(format: "%02d", m))m" }
        return "\(String(format: "%02d", m))m"
    }

    private func cdColor(_ date: Date) -> Color {
        let h = date.timeIntervalSinceNow / 3600
        if h <= 24 { return .red }
        if h <= 72 { return .orange }
        return .blue
    }
}

struct MacUpcomingList: View {
    let events: [FuseEventMac]
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        List(Array(events.enumerated()), id: \.element.id) { i, event in
            HStack {
                Text("\(i + 1)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.quaternary)
                    .frame(width: 24, alignment: .trailing)
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title).font(.system(size: 13, weight: .semibold))
                    Text(event.date.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute()))
                        .font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Spacer()
                Text(shortCD(event.date))
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundStyle(cdColor(event.date))
            }
            .padding(.vertical, 4)
        }
        .onReceive(timer) { now = $0 }
    }

    private func shortCD(_ date: Date) -> String {
        let s = max(0, date.timeIntervalSinceNow)
        let d = Int(s) / 86400; let h = (Int(s) % 86400) / 3600; let m = (Int(s) % 3600) / 60
        if d > 0 { return "\(d)d \(h)h" }
        if h > 0 { return "\(h)h \(String(format: "%02d", m))m" }
        return "\(String(format: "%02d", m))m"
    }
    private func cdColor(_ date: Date) -> Color {
        let h = date.timeIntervalSinceNow / 3600
        if h <= 24 { return .red }; if h <= 72 { return .orange }; return .blue
    }
}
