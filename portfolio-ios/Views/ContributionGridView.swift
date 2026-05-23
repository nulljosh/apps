import SwiftUI

struct ContributionGridView: View {
    let contributions: [Contribution]
    let eventMap: [String: [GitHubEvent]]
    let currentStreak: Int
    let longestStreak: Int
    let total: Int

    @State private var selectedContrib: Contribution?

    private let levels: [Color] = [
        Color(.systemGray6),
        Color(.systemGray4),
        Color(.systemGray3),
        Color(.systemGray2),
        Color(.label).opacity(0.8)
    ]

    private var firstDay: Int {
        guard let first = contributions.first else { return 0 }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Calendar.current.component(.weekday, from: formatter.date(from: first.date) ?? Date()) - 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            grid
            stats
        }
        .sheet(item: $selectedContrib) { contrib in
            DayDetailView(contrib: contrib, events: eventMap[contrib.date] ?? [])
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private var grid: some View {
        GeometryReader { geo in
            let cols = max(1, Int(ceil(Double(firstDay + contributions.count) / 7.0)))
            let cellSize = min(CGFloat(Int(geo.size.width / CGFloat(cols + 1))), 10)
            let gap: CGFloat = max(1, cellSize * 0.2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: gap) {
                    ForEach(0..<cols, id: \.self) { col in
                        VStack(spacing: gap) {
                            ForEach(0..<7, id: \.self) { row in
                                let idx = col * 7 + row - firstDay
                                if idx >= 0 && idx < contributions.count {
                                    let c = contributions[idx]
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(levels[min(c.level, 4)])
                                        .frame(width: cellSize, height: cellSize)
                                        .onTapGesture {
                                            if c.count > 0 { selectedContrib = c }
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(levels[0])
                                        .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 90)
    }

    private var stats: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(total) contributions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if currentStreak > 0 || longestStreak > 0 {
                    Text(streakText)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer()
            legend
        }
    }

    private var streakText: String {
        var parts: [String] = []
        if currentStreak > 0 { parts.append("streak: \(currentStreak)d") }
        if longestStreak > 0 { parts.append("best: \(longestStreak)d") }
        return parts.joined(separator: " · ")
    }

    private var legend: some View {
        HStack(spacing: 3) {
            Text("Less")
                .font(.system(size: 8))
                .foregroundStyle(.tertiary)
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { lvl in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(levels[lvl])
                        .frame(width: 8, height: 8)
                }
            }
            Text("More")
                .font(.system(size: 8))
                .foregroundStyle(.tertiary)
        }
    }
}

struct DayDetailView: View {
    let contrib: Contribution
    let events: [GitHubEvent]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formattedDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        Text(countText)
                            .font(.title3.weight(.semibold))
                    }
                    .padding(.vertical, 4)
                }
                if !events.isEmpty {
                    Section("Activity") {
                        ForEach(events.prefix(6)) { ev in
                            Text(ev.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Section {
                    Link(destination: githubURL) {
                        Label("View on GitHub", systemImage: "arrow.up.right.square")
                    }
                }
            }
            .navigationTitle("Contributions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        guard let d = f.date(from: contrib.date) else { return contrib.date }
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: d)
    }

    private var countText: String {
        contrib.count == 0 ? "No contributions" :
            "\(contrib.count) contribution\(contrib.count != 1 ? "s" : "")"
    }

    private var githubURL: URL {
        URL(string: "https://github.com/nulljosh?from=\(contrib.date)&to=\(contrib.date)&tab=overview")!
    }
}
