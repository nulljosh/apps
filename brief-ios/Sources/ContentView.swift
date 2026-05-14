import SwiftUI

struct ContentView: View {
    var body: some View {
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
