import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case radar = "Radar"
    case beacon = "Beacon"
    case economy = "Economy"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .radar: return "dot.radiowaves.left.and.right"
        case .beacon: return "bolt.fill"
        case .economy: return "dollarsign.circle"
        }
    }
}

struct ContentView: View {
    @State private var selected: SidebarItem = .radar

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selected) { item in
                Label(item.rawValue, systemImage: item.icon)
                    .tag(item)
            }
            .navigationSplitViewColumnWidth(min: 160, ideal: 180, max: 220)
            .listStyle(.sidebar)
        } detail: {
            switch selected {
            case .radar:
                RadarView()
            case .beacon:
                BeaconView()
            case .economy:
                EconomyView()
            }
        }
        .tint(Theme.accent)
    }
}

#Preview {
    ContentView()
}
