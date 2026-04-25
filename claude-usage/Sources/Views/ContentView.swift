import SwiftUI

struct ContentView: View {
    @Environment(UsageStore.self) private var store

    var body: some View {
        @Bindable var store = store

        NavigationSplitView {
            SidebarView()
        } detail: {
            switch store.selectedTab {
            case .dashboard:
                DashboardView()
            case .entries:
                EntriesView()
            case .charts:
                ChartsView()
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
