import SwiftUI
import SwiftData

struct JobsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Job.createdAt, order: .reverse) private var jobs: [Job]
    @State private var editing: Job?
    @State private var showAdd = false
    @State private var filter = "All"

    private var filtered: [Job] { filter == "All" ? jobs : jobs.filter { $0.status == filter } }

    var body: some View {
        List {
            ForEach(filtered) { j in
                MacJobRow(job: j).onTapGesture { editing = j }
            }
            .onDelete(perform: deleteJobs)
        }
        .navigationTitle("Jobs")
        .toolbar {
            ToolbarItem {
                Menu {
                    Button("All") { filter = "All" }; Divider()
                    ForEach(JOB_STATUSES, id: \.self) { status in Button(status) { filter = status } }
                } label: { Label(filter, systemImage: "line.3.horizontal.decrease.circle") }
            }
            ToolbarItem { Button("New Job") { showAdd = true } }
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

    func deleteJobs(_ offsets: IndexSet) { offsets.forEach { context.delete(filtered[$0]) } }
}

struct MacJobRow: View {
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
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(job.customer).fontWeight(.semibold)
                if !job.service.isEmpty { Text(job.service).font(.caption).foregroundStyle(.secondary) }
                if !job.address.isEmpty { Text(job.address).font(.caption).foregroundStyle(.secondary) }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(job.status).font(.caption.bold())
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .background(color.opacity(0.15)).foregroundStyle(color).clipShape(.capsule)
                if job.canAdvance {
                    Button("Advance") { job.advance() }.font(.caption).foregroundStyle(Color(hex: "0071e3"))
                        .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
