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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(CaseID.allCases) { c in
                        Button {
                            store.activeCase = c
                        } label: {
                            Label(c.title, systemImage: store.activeCase == c ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(store.activeCase.rawValue)
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
}
