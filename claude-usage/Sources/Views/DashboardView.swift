import SwiftUI

struct DashboardView: View {
    @Environment(UsageStore.self) private var store

    private var month: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: Date())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(month)
                    .font(.largeTitle.bold())
                    .padding(.top, 8)

                // Top stat cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(
                        title: "Conversations",
                        value: "\(store.currentMonthConversations)",
                        subtitle: "this month",
                        icon: "bubble.left.and.bubble.right.fill",
                        color: .blue
                    )
                    StatCard(
                        title: "Tokens",
                        value: formatTokens(store.currentMonthTokens),
                        subtitle: "estimated",
                        icon: "doc.text.fill",
                        color: .orange
                    )
                    StatCard(
                        title: "Cost",
                        value: formatBudget(store.currentMonthCost, budget: store.totalMonthlyBudget),
                        subtitle: store.settings.currency,
                        icon: "creditcard.fill",
                        color: store.totalMonthlyBudget > 0 && store.currentMonthCost > store.totalMonthlyBudget ? .red : .green
                    )
                }

                // Provider breakdown
                if !store.monthlyBreakdown().isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Provider Breakdown")
                            .font(.headline)

                        ForEach(store.monthlyBreakdown(), id: \.provider) { item in
                            ProviderRow(
                                provider: item.provider,
                                conversations: item.conversations,
                                tokens: item.tokens,
                                cost: item.cost,
                                budget: store.budget(for: item.provider),
                                currency: store.settings.currency
                            )
                        }
                    }
                    .padding(16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                // Activity strip
                VStack(alignment: .leading, spacing: 12) {
                    Text("Last 30 Days")
                        .font(.headline)
                    ActivityBarChart(data: store.last30DaysActivity())
                        .frame(height: 80)
                }
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                // Recent entries
                if !store.filteredEntries.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Entries")
                            .font(.headline)

                        ForEach(store.filteredEntries.prefix(5)) { entry in
                            EntryRow(entry: entry)
                        }
                    }
                    .padding(16)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                if store.filteredEntries.isEmpty {
                    ContentUnavailableView(
                        "No entries yet",
                        systemImage: "chart.bar",
                        description: Text("Add your first usage entry to get started.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }
            }
            .padding(24)
        }
        .navigationTitle("Dashboard")
        .navigationSubtitle(store.selectedProvider?.displayName ?? "All Providers")
    }

    private func formatTokens(_ n: Int) -> String {
        if n >= 1_000_000 { return String(format: "%.1fM", Double(n) / 1_000_000) }
        if n >= 1_000 { return String(format: "%.1fK", Double(n) / 1_000) }
        return "\(n)"
    }

    private func formatCost(_ d: Double) -> String {
        String(format: "$%.2f", d)
    }

    private func formatBudget(_ spent: Double, budget: Double) -> String {
        budget > 0 ? String(format: "$%.2f / $%.0f", spent, budget) : String(format: "$%.2f", spent)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)
                Spacer()
            }
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ProviderRow: View {
    let provider: AIProvider
    let conversations: Int
    let tokens: Int
    let cost: Double
    let budget: Double
    let currency: String

    private var isOver: Bool { budget > 0 && cost > budget }
    private var progress: Double { budget > 0 ? min(cost / budget, 1.0) : 0 }
    private var rowColor: Color { isOver ? .red : providerColor }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Circle()
                    .fill(rowColor)
                    .frame(width: 10, height: 10)
                Text(provider.displayName)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text("\(conversations) convos")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Group {
                    if budget > 0 {
                        Text(String(format: "$%.2f / $%.0f", cost, budget))
                    } else {
                        Text(String(format: "$%.2f", cost))
                    }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isOver ? .red : .primary)
                .frame(width: 80, alignment: .trailing)
            }
            if budget > 0 {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary.opacity(0.15))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(rowColor)
                            .frame(width: geo.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
        }
        .padding(.vertical, 4)
    }

    private var providerColor: Color {
        switch provider {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }
}

struct ActivityBarChart: View {
    let data: [(date: Date, conversations: Int)]

    private var maxVal: Int {
        max(data.map(\.conversations).max() ?? 1, 1)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(data.indices, id: \.self) { i in
                let item = data[i]
                let height = item.conversations == 0
                    ? 2.0
                    : max(4.0, 80.0 * Double(item.conversations) / Double(maxVal))
                RoundedRectangle(cornerRadius: 2)
                    .fill(item.conversations > 0 ? Color.accentColor : Color.secondary.opacity(0.2))
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
