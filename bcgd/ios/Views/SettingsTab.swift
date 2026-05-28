import SwiftUI
import SwiftData

struct SettingsTab: View {
    @Query private var parts: [Part]
    @Query private var jobs: [Job]
    @Environment(\.modelContext) private var context
    @AppStorage("bcgd_pin") private var storedPin = ""
    @AppStorage("bcgd_alerts_enabled") private var alertsEnabled = true
    @AppStorage("bcgd_alert_email") private var alertEmail = ""
    @State private var showPinSheet = false
    @State private var showImport = false
    @State private var exportItem: ExportItem?
    @State private var toast: String?

    var body: some View {
        NavigationView {
            Form {
                Section("Notifications") {
                    Toggle("Low stock alerts", isOn: $alertsEnabled)
                        .onChange(of: alertsEnabled) { _, v in
                            let lowParts = v ? parts.filter { $0.isLowStock } : []
                            let lowCount = lowParts.count
                            let firstName = lowParts.first?.name ?? ""
                            Task { await NotificationService.scheduleAlertsIfNeeded(lowCount: lowCount, firstName: firstName) }
                        }
                }
                Section("Contact") {
                    TextField("Alert email", text: $alertEmail)
                        .keyboardType(.emailAddress).autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                Section("PIN") {
                    Button(storedPin.isEmpty ? "Set PIN" : "Change PIN") { showPinSheet = true }
                    if !storedPin.isEmpty {
                        Button("Remove PIN", role: .destructive) { storedPin = "" }
                    }
                }
                Section("Data") {
                    Button("Export backup") {
                        let d = BackupService.export(parts: parts, jobs: jobs)
                        if let url = BackupService.writeTemp(d) { exportItem = ExportItem(url: url) }
                    }
                    Button("Import backup") { showImport = true }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPinSheet) {
                PinSetupSheet { storedPin = $0 }
            }
            .sheet(item: $exportItem) { item in
                ShareSheet(items: [item.url])
            }
            .fileImporter(isPresented: $showImport, allowedContentTypes: [.json]) { result in
                guard case .success(let url) = result,
                      url.startAccessingSecurityScopedResource(),
                      let backup = BackupService.load(from: url) else { return }
                url.stopAccessingSecurityScopedResource()
                backup.parts.forEach { context.insert(Part.from($0)) }
                backup.jobs.forEach { context.insert(Job.from($0)) }
                toast = "Imported \(backup.parts.count) parts, \(backup.jobs.count) jobs"
                Task { try? await Task.sleep(for: .seconds(2.5)); toast = nil }
            }
            .overlay(alignment: .bottom) {
                if let msg = toast {
                    Text(msg).padding(.horizontal, 16).padding(.vertical, 10)
                        .background(.ultraThinMaterial).clipShape(.capsule).padding(.bottom, 24)
                }
            }
            .animation(.easeInOut, value: toast)
        }
    }
}

struct ExportItem: Identifiable { let id = UUID(); let url: URL }

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

struct PinSetupSheet: View {
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var pin = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Enter a 4-digit PIN").font(.headline)
                PinKeypad(pin: $pin, maxLength: 4)
                if pin.count == 4 {
                    Button("Save PIN") { onSave(pin); dismiss() }
                        .buttonStyle(.borderedProminent).tint(Color(hex: "0071e3"))
                }
            }
            .padding()
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } } }
        }
    }
}
