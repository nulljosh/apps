import SwiftUI
import SwiftData

struct DashboardTab: View {
    @Query private var parts: [Part]
    @Query private var jobs: [Job]

    private var low: [Part] { parts.filter { $0.isLowStock } }
    private var totalValue: Double { parts.reduce(0) { $0 + $1.totalValue } }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCard("SKUs", "\(parts.count)")
                        StatCard("Units", "\(parts.reduce(0) { $0 + $1.quantity })")
                        StatCard("Value", totalValue > 0 ? "~$\(Int(totalValue))" : "--")
                        StatCard("Low Stock", "\(low.count)", alert: !low.isEmpty)
                        let leads = jobs.filter { $0.status == "Lead" }.count
                        let sched = jobs.filter { $0.status == "Scheduled" }.count
                        if leads > 0 { StatCard("Leads", "\(leads)") }
                        if sched > 0 { StatCard("Scheduled", "\(sched)") }
                    }
                    if !low.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Low Stock").font(.headline).foregroundStyle(.secondary)
                            ForEach(low) { p in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(p.name).font(.subheadline.weight(.medium))
                                        Text(p.sku).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(p.quantity)/\(p.minThreshold)")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(p.isOutOfStock ? .red : .orange)
                                    Text(p.isOutOfStock ? "OUT" : "LOW")
                                        .font(.caption.bold())
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background((p.isOutOfStock ? Color.red : .orange).opacity(0.15))
                                        .foregroundStyle(p.isOutOfStock ? .red : .orange)
                                        .clipShape(.capsule)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("BC Garage Doors")
            .task {
                let lowParts = parts.filter { $0.isLowStock }
                await NotificationService.scheduleAlertsIfNeeded(lowCount: lowParts.count, firstName: lowParts.first?.name ?? "")
            }
        }
    }
}

struct StatCard: View {
    let label: String; let value: String; var alert = false
    init(_ label: String, _ value: String, alert: Bool = false) {
        self.label = label; self.value = value; self.alert = alert
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title2.bold()).foregroundStyle(alert ? .red : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(alert ? Color.red.opacity(0.4) : Color.white.opacity(0.08), lineWidth: 1))
    }
}
