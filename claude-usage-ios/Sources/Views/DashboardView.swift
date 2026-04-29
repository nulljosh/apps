import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(UsageStore.self) private var store

    private var monthLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero stat
                    HeroCard(
                        conversations: store.currentMonthConversations,
                        tokens: store.currentMonthTokens,
                        cost: store.currentMonthCost,
                        budget: store.totalMonthlyBudget,
                        currency: store.settings.currency
                    )

                    // Activity strip
                    ActivitySection(data: store.last30DaysActivity())

                    // Provider breakdown
                    if !store.monthlyBreakdown().isEmpty {
                        BreakdownSection(
                            breakdown: store.monthlyBreakdown(),
                            budgetFor: { store.budget(for: $0) }
                        )
                    }

                    // Recent entries
                    if !store.filteredEntries.isEmpty {
                        RecentSection(entries: Array(store.filteredEntries.prefix(5)))
                    }

                    if store.entries.isEmpty {
                        ContentUnavailableView(
                            "No entries yet",
                            systemImage: "chart.bar",
                            description: Text("Tap + to log your first session.")
                        )
                        .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .navigationTitle(monthLabel)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { store.showingAddEntry = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct HeroCard: View {
    let conversations: Int
    let tokens: Int
    let cost: Double
    let budget: Double
    let currency: String

    private var isOver: Bool { budget > 0 && cost > budget }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Conversations")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(conversations)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 12) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Tokens")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(formatTokens(tokens))
                            .font(.title3.weight(.semibold).monospacedDigit())
                    }
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Cost (\(currency))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Group {
                            if budget > 0 {
                                Text(String(format: "$%.2f / $%.0f", cost, budget))
                            } else {
                                Text(String(format: "$%.2f", cost))
                            }
                        }
                        .font(.title3.weight(.semibold).monospacedDigit())
                        .foregroundStyle(isOver ? .red : .primary)
                    }
                }
            }
            .padding(20)

            if budget > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.12))
                            .frame(height: 3)
                        Rectangle()
                            .fill(isOver ? Color.red : Color.accentColor)
                            .frame(width: geo.size.width * min(cost / budget, 1.0), height: 3)
                    }
                }
                .frame(height: 3)
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func formatTokens(_ n: Int) -> String {
        if n >= 1_000_000 { return String(format: "%.1fM", Double(n) / 1_000_000) }
        if n >= 1_000 { return String(format: "%.1fK", Double(n) / 1_000) }
        return "\(n)"
    }
}

struct ActivitySection: View {
    let data: [(date: Date, conversations: Int)]

    private var maxVal: Int { max(data.map(\.conversations).max() ?? 1, 1) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 30 Days")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)

            HStack(alignment: .bottom, spacing: 3) {
                ForEach(data.indices, id: \.self) { i in
                    let item = data[i]
                    let h = item.conversations == 0
                        ? 3.0
                        : max(6.0, 56.0 * Double(item.conversations) / Double(maxVal))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(item.conversations > 0 ? Color.accentColor : Color.secondary.opacity(0.15))
                        .frame(maxWidth: .infinity)
                        .frame(height: h)
                }
            }
            .frame(height: 56)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct BreakdownSection: View {
    let breakdown: [(provider: AIProvider, conversations: Int, cost: Double)]
    let budgetFor: (AIProvider) -> Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("By Provider")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)

            VStack(spacing: 0) {
                ForEach(breakdown.indices, id: \.self) { i in
                    let item = breakdown[i]
                    let budget = budgetFor(item.provider)
                    let isOver = budget > 0 && item.cost > budget
                    VStack(spacing: 6) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(isOver ? .red : item.provider.color)
                                .frame(width: 10, height: 10)
                            Text(item.provider.displayName)
                                .font(.subheadline)
                            Spacer()
                            Text("\(item.conversations) convos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Group {
                                if budget > 0 {
                                    Text(String(format: "$%.2f / $%.0f", item.cost, budget))
                                } else {
                                    Text(String(format: "$%.2f", item.cost))
                                }
                            }
                            .font(.subheadline.weight(.semibold).monospacedDigit())
                            .foregroundStyle(isOver ? .red : .primary)
                            .frame(width: 80, alignment: .trailing)
                        }
                        if budget > 0 {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(Color.secondary.opacity(0.15))
                                        .frame(height: 3)
                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(isOver ? Color.red : item.provider.color)
                                        .frame(width: geo.size.width * min(item.cost / budget, 1.0), height: 3)
                                }
                            }
                            .frame(height: 3)
                        }
                    }
                    .padding(.vertical, 10)

                    if i < breakdown.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct RecentSection: View {
    @Environment(UsageStore.self) private var store
    let entries: [UsageEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .kerning(0.5)

            VStack(spacing: 0) {
                ForEach(entries.indices, id: \.self) { i in
                    let entry = entries[i]
                    Button(action: { store.editingEntry = entry }) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(entry.provider.color)
                                .frame(width: 10, height: 10)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.provider.displayName)
                                    .font(.subheadline.weight(.medium))
                                if !entry.model.isEmpty {
                                    Text(entry.model)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(entry.date, format: .dateTime.month(.abbreviated).day())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "$%.2f", entry.costEstimate))
                                    .font(.subheadline.weight(.semibold).monospacedDigit())
                            }
                        }
                        .padding(.vertical, 10)
                        .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)

                    if i < entries.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
