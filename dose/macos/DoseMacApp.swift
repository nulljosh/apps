import SwiftUI

@main
struct DoseMacApp: App {
    @State private var store = BodyworkSessionStore()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } detail: {
                Text("Select a section from the sidebar")
                    .foregroundStyle(.secondary)
            }
            .environment(store)
            .frame(minWidth: 800, minHeight: 550)
        }
        .defaultSize(width: 1050, height: 680)
        .windowStyle(.titleBar)
    }
}
