import SwiftUI

struct RootView: View {
    @Environment(UsageStore.self) private var store

    var body: some View {
        @Bindable var store = store

        TabView {
            Tab("Dashboard", systemImage: "chart.bar.fill") {
                DashboardView()
            }
            Tab("Entries", systemImage: "list.bullet.rectangle") {
                EntriesView()
            }
            Tab("Charts", systemImage: "chart.line.uptrend.xyaxis") {
                ChartsView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .sheet(isPresented: $store.showingAddEntry) {
            EntryFormView(entry: nil)
        }
        .sheet(item: $store.editingEntry) { entry in
            EntryFormView(entry: entry)
        }
    }
}
