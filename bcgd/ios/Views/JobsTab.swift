import SwiftUI
import SwiftData

struct JobsTab: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Job.createdAt, order: .reverse) private var jobs: [Job]
    @State private var editing: Job?
    @State private var showAdd = false
    @State private var filter = "All"

    private var filtered: [Job] { filter == "All" ? jobs : jobs.filter { $0.status == filter } }

    var body: some View {
        NavigationView {
            List {
                ForEach(filtered) { j in
                    JobRow(job: j).onTapGesture { editing = j }
                }
                .onDelete { idx in idx.forEach { context.delete(filtered[$0]) } }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("All") { filter = "All" }
                        Divider()
                        ForEach(JOB_STATUSES, id: \.self) { status in Button(status) { filter = status } }
                    } label: { Label(filter, systemImage: "line.3.horizontal.decrease.circle") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAdd) {
                JobFormSheet(job: nil) { context.insert(Job.from($0)) }
            }
            .sheet(item: $editing) { j in
                JobFormSheet(job: j.data) { d in
                    j.customer = d.customer; j.address = d.address; j.phone = d.phone
                    j.email = d.email; j.service = d.service; j.status = d.status
                    j.notes = d.notes; j.scheduledAt = d.scheduledAt
                }
            }
        }
    }
}

struct JobRow: View {
    let job: Job
    private var color: Color {
        switch job.status {
        case "Lead": return .purple
        case "Scheduled": return Color(hex: "0071e3")
        case "In Progress": return .orange
        case "Done": return .green
        default: return .secondary
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(job.customer).font(.subheadline.weight(.semibold))
                Spacer()
                Text(job.status).font(.caption.bold())
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(color.opacity(0.15)).foregroundStyle(color).clipShape(.capsule)
            }
            if !job.service.isEmpty { Text(job.service).font(.caption).foregroundStyle(.secondary) }
            if !job.address.isEmpty { Text(job.address).font(.caption).foregroundStyle(.secondary) }
            if job.canAdvance {
                Button("Advance to \(JOB_STATUSES[job.statusIndex + 1])") { job.advance() }
                    .font(.caption.weight(.medium)).foregroundStyle(Color(hex: "0071e3")).buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}
