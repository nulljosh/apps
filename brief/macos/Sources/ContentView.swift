import SwiftUI

struct ContentView: View {
    @Environment(Store.self) private var store
    @State private var selection: String? = "case"

    var body: some View {
        @Bindable var store = store
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                Section {
                    Label("Case", systemImage: "doc.text").tag("case")
                    Label("Money", systemImage: "chart.bar").tag("money")
                    Label("Actions", systemImage: "checklist").tag("actions")
                }
            }
            .navigationTitle(store.activeCase.rawValue)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Menu {
                        ForEach(CaseID.allCases) { c in
                            Button {
                                store.activeCase = c
                            } label: {
                                if store.activeCase == c { Label(c.title, systemImage: "checkmark") }
                                else { Text(c.title) }
                            }
                        }
                    } label: {
                        Image(systemName: "folder")
                    }
                }
            }
        } detail: {
            switch selection {
            case "money":   MoneyTabView()
            case "actions": ActionsTabView()
            default:        CaseTabView()
            }
        }
    }
}
