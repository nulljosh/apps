import SwiftUI

struct ContentView: View {
    @Environment(Store.self) private var store

    var body: some View {
        @Bindable var store = store
        TabView {
            CaseTabView()
                .tabItem { Label("Case", systemImage: "doc.text") }
            MoneyTabView()
                .tabItem { Label("Money", systemImage: "chart.bar") }
            ActionsTabView()
                .tabItem { Label("Actions", systemImage: "checklist") }
        }
    }
}
