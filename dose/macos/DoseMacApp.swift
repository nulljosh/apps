import SwiftUI

@main
struct DoseMacApp: App {
    @State private var store = BodyworkSessionStore()
    @State private var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(dataStore: dataStore)
            } detail: {
                MacDashboardView(dataStore: dataStore)
            }
            .environment(store)
            .frame(minWidth: 800, minHeight: 550)
        }
        .defaultSize(width: 1050, height: 680)
        .windowStyle(.titleBar)
    }
}
