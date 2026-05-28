import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var parts: [Part]
    @Query private var jobs: [Job]

    private var low: [Part] { parts.filter { $0.isLowStock } }
    private var totalValue: Double { parts.reduce(0) { $0 + $1.totalValue } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    MacStatCard("SKUs", "\(parts.count)")
                    MacStatCard("Units", "\(parts.reduce(0) { $0 + $1.quantity })")
                    MacStatCard("Value", totalValue > 0 ? "~$\(Int(totalValue))" : "--")
                    MacStatCard("Low Stock", "\(low.count)", alert: !low.isEmpty)
                }
                if !low.isEmpty {
                    GroupBox("Low Stock Alerts") {
                        ForEach(low) { p in
                            HStack {
                                Text(p.name).fontWeight(.medium)
                                Text(p.sku).foregroundStyle(.secondary).font(.caption)
                                Spacer()
                                Text("\(p.quantity)/\(p.minThreshold)")
                                    .foregroundStyle(p.isOutOfStock ? .red : .orange).bold()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
                GroupBox("Jobs Pipeline") {
                    let active = jobs.filter { $0.status != "Done" && $0.status != "Cancelled" }
                    if active.isEmpty {
                        Text("No active jobs.").foregroundStyle(.secondary)
                    } else {
                        ForEach(active) { j in
                            HStack {
                                Text(j.customer).fontWeight(.medium)
                                Text(j.service).foregroundStyle(.secondary).font(.caption)
                                Spacer()
                                Text(j.status).font(.caption.bold())
                                    .padding(.horizontal, 8).padding(.vertical, 2)
                                    .background(statusColor(j.status).opacity(0.15))
                                    .foregroundStyle(statusColor(j.status))
                                    .clipShape(.capsule)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .task {
            let lowCount = parts.filter { $0.isLowStock }.count
            let firstName = parts.first(where: { $0.isLowStock })?.name ?? ""
            await NotificationService.scheduleAlertsIfNeeded(lowCount: lowCount, firstName: firstName)
        }
    }

    func statusColor(_ s: String) -> Color {
        switch s {
        case "Lead": return .purple
        case "Scheduled": return Color(hex: "0071e3")
        case "In Progress": return .orange
        case "Done": return .green
        default: return .secondary
        }
    }
}

struct MacStatCard: View {
    let label: String; let value: String; var alert = false
    init(_ l: String, _ v: String, alert: Bool = false) { label = l; value = v; self.alert = alert }
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 4) {
                Text(label).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.title2.bold()).foregroundStyle(alert ? .red : .primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
