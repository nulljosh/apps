import SwiftUI

struct ContentView: View {
    @State private var selection: String? = "case"

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                Label("Case", systemImage: "doc.text").tag("case")
                Label("Money", systemImage: "chart.bar").tag("money")
                Label("Actions", systemImage: "checklist").tag("actions")
            }
            .navigationTitle("Brief")
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            switch selection {
            case "money":   MoneyTabView()
            case "actions": ActionsTabView()
            default:        CaseTabView()
            }
        }
    }
}
