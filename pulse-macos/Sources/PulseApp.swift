import SwiftUI

@main
struct PulseApp: App {
    @State private var store = SessionStore()
    @State private var selection: SidebarItem? = .symptoms

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List(SidebarItem.allCases, selection: $selection) { item in
                    Label(item.rawValue, systemImage: item.icon)
                        .tag(item)
                        .padding(.vertical, 2)
                }
                .navigationSplitViewColumnWidth(min: 200, ideal: 220)
                .listStyle(.sidebar)
            } detail: {
                Group {
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
                        ContentUnavailableView("Pulse", systemImage: "hand.raised.fingers.spread", description: Text("Select a section from the sidebar"))
                    }
                }
            }
            .environment(store)
            .frame(minWidth: 800, minHeight: 550)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 1050, height: 680)
    }
}
