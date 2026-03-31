import SwiftUI

@main
struct PulseApp: App {
    @State private var store = SessionStore()
    @State private var selection: SidebarItem? = .feet

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List(SidebarItem.allCases, selection: $selection) { item in
                    Label(item.rawValue, systemImage: item.icon)
                        .tag(item)
                }
                .navigationSplitViewColumnWidth(min: 220, ideal: 240)
            } detail: {
                switch selection {
                case .feet:
                    MacReflexologyView(area: .feet)
                case .hands:
                    MacReflexologyView(area: .hands)
                case .points:
                    MacMeridianListView()
                case .symptoms:
                    MacSymptomFinderView()
                case .history:
                    MacSessionHistoryView()
                case nil:
                    Text("Select a section from the sidebar")
                        .foregroundStyle(.secondary)
                }
            }
            .environment(store)
            .frame(minWidth: 800, minHeight: 550)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 1000, height: 650)
    }
}
