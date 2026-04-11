import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(UsageStore.self) private var store
    @State private var showingExporter = false
    @State private var showingImporter = false
    @State private var importError: String? = nil
    @State private var showingClearConfirm = false
    @State private var exportContent = ""

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            Form {
                Section("Subscriptions") {
                    HStack {
                        Text("Claude Monthly")
                        Spacer()
                        TextField("Amount", value: $store.settings.claudeMonthly, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                    }
                    HStack {
                        Text("ChatGPT Monthly")
                        Spacer()
                        TextField("Amount", value: $store.settings.chatgptMonthly, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                    }
                    HStack {
                        Text("Gemini Monthly")
                        Spacer()
                        TextField("Amount", value: $store.settings.geminiMonthly, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                    }
                }

                Section("General") {
                    Picker("Currency", selection: $store.settings.currency) {
                        Text("CAD").tag("CAD")
                        Text("USD").tag("USD")
                        Text("GBP").tag("GBP")
                        Text("EUR").tag("EUR")
                    }
                    Picker("Default Provider", selection: $store.settings.defaultProvider) {
                        ForEach(AIProvider.allCases) { p in
                            Text(p.displayName).tag(p)
                        }
                    }
                }

                Section("Data") {
                    Button("Export JSON") {
                        exportContent = store.exportJSON()
                        showingExporter = true
                    }
                    Button("Import JSON") {
                        showingImporter = true
                    }
                }

                Section {
                    Button("Clear All Data", role: .destructive) {
                        showingClearConfirm = true
                    }
                }
            }
            .navigationTitle("Settings")
            .onChange(of: store.settings) { store.save() }
            .alert("Import Error", isPresented: .constant(importError != nil)) {
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
            .sheet(isPresented: $showingExporter) {
                ShareSheet(items: [exportContent])
            }
            .sheet(isPresented: $showingImporter) {
                DocumentPickerView { content in
                    do {
                        try store.importJSON(content)
                    } catch {
                        importError = error.localizedDescription
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uvc: UIActivityViewController, context: Context) {}
}

struct DocumentPickerView: UIViewControllerRepresentable {
    let onPick: (String) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onPick: onPick) }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uvc: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (String) -> Void
        init(onPick: @escaping (String) -> Void) { self.onPick = onPick }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first,
                  url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            if let content = try? String(contentsOf: url) {
                onPick(content)
            }
        }
    }
}
