import SwiftUI

enum NavSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case inventory = "Inventory"
    case jobs      = "Jobs"
    case settings  = "Settings"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .dashboard: return "gauge.badge.plus"
        case .inventory: return "shippingbox"
        case .jobs:      return "wrench.and.screwdriver"
        case .settings:  return "gear"
        }
    }
}

struct ContentView: View {
    @State private var selection: NavSection? = .dashboard

    var body: some View {
        NavigationSplitView {
            List(NavSection.allCases, selection: $selection) { s in
                Label(s.rawValue, systemImage: s.icon)
            }
            .navigationTitle("BC Garage Doors")
            .navigationSplitViewColumnWidth(min: 160, ideal: 180)
        } detail: {
            switch selection {
            case .dashboard, nil: DashboardView()
            case .inventory:      InventoryView()
            case .jobs:           JobsView()
            case .settings:       SettingsView()
            }
        }
        .tint(Color(hex: "0071e3"))
    }
}
