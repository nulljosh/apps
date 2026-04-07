import SwiftUI

struct DashboardView: View {
    var store: SharedDataStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    doseCountCard
                    lastDoseCard
                    activeStackCard
                    NavigationLink {
                        FacemaxxingView()
                    } label: {
                        HStack {
                            Image(systemName: "face.smiling")
                            Text("Facemaxxing").font(.caption)
                            Spacer()
                            Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.purple.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Dose")
        }
        .onAppear { store.reload() }
    }

    private var doseCountCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Today")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("\(store.doseCount)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.cyan)
            }
            Spacer()
            Image(systemName: "pill.fill")
                .font(.title2)
                .foregroundStyle(.cyan.opacity(0.6))
        }
        .padding()
        .background(.cyan.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }

    private var lastDoseCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last Dose")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(store.lastDoseName)
                .font(.headline)

            if let latest = store.recentEntries.first {
                Text(latest.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    + Text(" ago")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }

    private var activeStackCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Active Stack")
                .font(.caption2)
                .foregroundStyle(.secondary)

            if store.activePills.isEmpty {
                Text("No active doses")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(store.activePills) { pill in
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)
                        Text(pill.name)
                            .font(.caption)
                        Spacer()
                        Text("\(pill.count)x")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }
}
