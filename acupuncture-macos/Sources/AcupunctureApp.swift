import SwiftUI

@main
struct AcupunctureApp: App {
    @State private var store = SessionStore()

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
        .windowStyle(.titleBar)
        .defaultSize(width: 1000, height: 650)
    }
}
