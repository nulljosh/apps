import WidgetKit
import SwiftUI

// MARK: - Entry

struct UsageWidgetEntry: TimelineEntry {
    let date: Date
    let conversations: Int
    let cost: Double
    let currency: String
    let monthLabel: String
}

// MARK: - Provider

struct UsageWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> UsageWidgetEntry {
        UsageWidgetEntry(date: Date(), conversations: 42, cost: 136.60, currency: "CAD", monthLabel: "April 2026")
    }

    func getSnapshot(in context: Context, completion: @escaping (UsageWidgetEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UsageWidgetEntry>) -> Void) {
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        completion(Timeline(entries: [entry()], policy: .after(nextUpdate)))
    }

    private func entry() -> UsageWidgetEntry {
        let defaults = UserDefaults.standard
        var conversations = 0
        var cost = 0.0
        var currency = "CAD"

        if let data = defaults.data(forKey: "claude_usage_entries_v1"),
           let entries = try? JSONDecoder().decode([WidgetEntry].self, from: data) {
            let cal = Calendar.current
            let now = Date()
            let month = entries.filter { e in
                guard let d = ISO8601DateFormatter().date(from: e.date) else { return false }
                return cal.isDate(d, equalTo: now, toGranularity: .month)
            }
            conversations = month.reduce(0) { $0 + $1.conversations }
            cost = month.reduce(0) { $0 + $1.costEstimate }
        }

        if let data = defaults.data(forKey: "claude_usage_settings_v1"),
           let settings = try? JSONDecoder().decode(WidgetSettings.self, from: data) {
            currency = settings.currency
        }

        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return UsageWidgetEntry(
            date: Date(),
            conversations: conversations,
            cost: cost,
            currency: currency,
            monthLabel: fmt.string(from: Date())
        )
    }
}

// Minimal decodable structs for widget (no SwiftUI dependency)
private struct WidgetEntry: Codable {
    var date: String
    var conversations: Int
    var costEstimate: Double
}

private struct WidgetSettings: Codable {
    var currency: String
}

// MARK: - View

struct UsageWidgetView: View {
    let entry: UsageWidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: UsageWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(red: 0.85, green: 0.47, blue: 0.02))
                Text("Usage")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(entry.conversations)")
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text("convos")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(String(format: "$%.2f %@", entry.cost, entry.currency))
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color(red: 0.85, green: 0.47, blue: 0.02))
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(.regularMaterial, for: .widget)
    }
}

struct MediumWidgetView: View {
    let entry: UsageWidgetEntry

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color(red: 0.85, green: 0.47, blue: 0.02))
                    Text("Claude Usage")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(entry.monthLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text("\(entry.conversations)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))

                Text("conversations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text("Cost")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(String(format: "$%.2f", entry.cost))
                    .font(.title2.weight(.bold).monospacedDigit())
                Text(entry.currency)
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.85, green: 0.47, blue: 0.02))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(.regularMaterial, for: .widget)
    }
}

// MARK: - Widget

@main
struct UsageWidget: Widget {
    let kind = "com.nulljosh.claude-usage-ios.widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UsageWidgetProvider()) { entry in
            UsageWidgetView(entry: entry)
        }
        .configurationDisplayName("Claude Usage")
        .description("Monthly conversation count and cost at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
