import SwiftUI
import SwiftData
import UserNotifications

struct SettingsView: View {
    @Query private var parts: [Part]
    @Query private var jobs: [Job]
    @Environment(\.modelContext) private var context
    @AppStorage("bcgd_alerts_enabled") private var alertsEnabled = true
    @AppStorage("bcgd_alert_email") private var alertEmail = ""
    @State private var exportItem: URL?
    @State private var showImport = false
    @State private var toast: String?

    var body: some View {
        Form {
            Section("Notifications") {
                Toggle("Low stock alerts", isOn: $alertsEnabled)
                    .onChange(of: alertsEnabled) { _, v in
                        if !v { Task { await UNUserNotificationCenter.current().removeAllPendingNotificationRequests() } }
                    }
            }
            Section("Contact") {
                TextField("Alert email", text: $alertEmail)
            }
            Section("Data") {
                Button("Export backup") { exportData() }
                Button("Import backup") { showImport = true }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .fileImporter(isPresented: $showImport, allowedContentTypes: [.json]) { result in
            guard case .success(let url) = result,
                  url.startAccessingSecurityScopedResource(),
                  let backup = BackupService.load(from: url) else { return }
            url.stopAccessingSecurityScopedResource()
            backup.parts.forEach { context.insert(Part.from($0)) }
            backup.jobs.forEach { context.insert(Job.from($0)) }
            toast = "Imported \(backup.parts.count) parts, \(backup.jobs.count) jobs"
        }
        .overlay(alignment: .bottom) {
            if let msg = toast {
                Text(msg).padding().background(.regularMaterial).clipShape(.capsule).padding(.bottom, 16)
                    .onAppear { Task { try? await Task.sleep(for: .seconds(2.5)); toast = nil } }
            }
        }
    }

    func exportData() {
        let data = BackupService.export(parts: parts, jobs: jobs)
        guard let url = BackupService.writeTemp(data) else { return }
        let dest = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("bcgd-backup-\(Int(Date().timeIntervalSince1970)).json")
        try? FileManager.default.copyItem(at: url, to: dest)
        toast = "Saved to Downloads"
    }
}
