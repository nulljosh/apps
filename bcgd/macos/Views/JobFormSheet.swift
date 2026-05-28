import SwiftUI

struct JobFormSheet: View {
    let job: JobData?
    let onSave: (JobData) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var customer = ""; @State private var address = ""
    @State private var phone = ""; @State private var email = ""
    @State private var service = ""; @State private var status = "Lead"
    @State private var notes = ""; @State private var scheduledAt = ""

    var body: some View {
        Form {
            Section("Customer") {
                TextField("Name", text: $customer)
                TextField("Phone", text: $phone)
                TextField("Email", text: $email)
                TextField("Address", text: $address)
            }
            Section("Job") {
                Picker("Service", selection: $service) {
                    Text("Select...").tag("")
                    ForEach(JOB_SERVICES, id: \.self) { Text($0) }
                }
                Picker("Status", selection: $status) { ForEach(JOB_STATUSES, id: \.self) { Text($0) } }
                TextField("Scheduled (YYYY-MM-DD)", text: $scheduledAt)
            }
            Section("Notes") { TextEditor(text: $notes).frame(minHeight: 80) }
        }
        .formStyle(.grouped)
        .frame(minWidth: 440, minHeight: 400)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(JobData(id: job?.id ?? UUID().uuidString, customer: customer,
                        address: address, phone: phone, email: email, service: service,
                        status: status, notes: notes, scheduledAt: scheduledAt,
                        createdAt: job?.createdAt ?? ISO8601DateFormatter().string(from: Date())))
                    dismiss()
                }.disabled(customer.isEmpty)
            }
        }
        .onAppear { if let j = job {
            customer = j.customer; address = j.address; phone = j.phone
            email = j.email; service = j.service; status = j.status
            notes = j.notes; scheduledAt = j.scheduledAt
        }}
    }
}
