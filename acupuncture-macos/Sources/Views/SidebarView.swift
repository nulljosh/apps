import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case feet = "Foot Reflexology"
    case hands = "Hand Reflexology"
    case points = "Acupuncture Points"
    case symptoms = "What Hurts?"
    case history = "Session History"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .feet: "shoe"
        case .hands: "hand.raised.fingers.spread"
        case .points: "target"
        case .symptoms: "cross.circle"
        case .history: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        }
    }
}

struct SidebarView: View {
    @State private var selection: SidebarItem? = .feet

    var body: some View {
        List(SidebarItem.allCases, selection: $selection) { item in
            NavigationLink(value: item) {
                Label(item.rawValue, systemImage: item.icon)
            }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 220)
        .navigationDestination(for: SidebarItem.self) { item in
            switch item {
            case .feet:
                MacReflexologyView(area: .feet)
            case .hands:
                MacReflexologyView(area: .hands)
            case .points:
                MacMeridianListView()
            case .symptoms:
                MacSymptomFinderView()
            case .history:
                MacSessionHistoryView()
            }
        }
    }
}
