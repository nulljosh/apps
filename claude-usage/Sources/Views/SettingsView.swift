import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(UsageStore.self) private var store
    @State private var showingImporter = false
    @State private var showingExporter = false
    @State private var importError: String? = nil
    @State private var showingClearConfirm = false

    var body: some View {
        @Bindable var store = store

        Form {
            Section("Subscriptions") {
                HStack {
                    Text("Claude Monthly")
                    Spacer()
                    TextField("Amount", value: $store.settings.claudeMonthly, format: .number)
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("ChatGPT Monthly")
                    Spacer()
                    TextField("Amount", value: $store.settings.chatgptMonthly, format: .number)
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Gemini Monthly")
                    Spacer()
                    TextField("Amount", value: $store.settings.geminiMonthly, format: .number)
                        .frame(width: 80)
                        .multilineTextAlignment(.trailing)
                }
            }

            Section("General") {
                HStack {
                    Text("Currency")
                    Spacer()
                    Picker("", selection: $store.settings.currency) {
                        Text("CAD").tag("CAD")
                        Text("USD").tag("USD")
                        Text("GBP").tag("GBP")
                        Text("EUR").tag("EUR")
                    }
                    .pickerStyle(.menu)
                    .frame(width: 80)
                }

                Picker("Default Provider", selection: $store.settings.defaultProvider) {
                    ForEach(AIProvider.allCases) { p in
                        Text(p.displayName).tag(p)
                    }
                }
            }

            Section("Data") {
                Button("Export JSON...") {
                    let panel = NSSavePanel()
                    panel.allowedContentTypes = [.json]
                    panel.nameFieldStringValue = "claude-usage-export.json"
                    if panel.runModal() == .OK, let url = panel.url {
                        try? store.exportJSON().write(to: url, atomically: true, encoding: .utf8)
                    }
                }

                Button("Import JSON...") {
                    let panel = NSOpenPanel()
                    panel.allowedContentTypes = [.json]
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK, let url = panel.url,
                       let content = try? String(contentsOf: url) {
                        do {
                            try store.importJSON(content)
                        } catch {
                            importError = error.localizedDescription
                        }
                    }
                }

                Button("Clear All Data", role: .destructive) {
                    showingClearConfirm = true
                }
                .foregroundStyle(.red)
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 440)
        .navigationTitle("Settings")
        .alert("Error importing", isPresented: .constant(importError != nil)) {
            Button("OK") { importError = nil }
        } message: {
            Text(importError ?? "")
        }
        .confirmationDialog("Clear all usage data?", isPresented: $showingClearConfirm) {
            Button("Clear All Data", role: .destructive) {
                store.entries = []
                store.save()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This cannot be undone.")
        }
        .onChange(of: store.settings) { store.save() }
    }
}
