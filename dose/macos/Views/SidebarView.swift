import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case feet = "Feet"
    case hands = "Hands"
    case abdomen = "Abdomen"
    case meridians = "Meridians"
    case symptoms = "Symptoms"
    case sessions = "Sessions"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .feet: "shoe.fill"
        case .hands: "hand.raised.fingers.spread"
        case .abdomen: "figure.stand"
        case .meridians: "target"
        case .symptoms: "cross.circle"
        case .sessions: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .feet: MacReflexologyView(mode: .feet)
        case .hands: MacReflexologyView(mode: .hands)
        case .abdomen: MacAbdomenView()
        case .meridians: MacMeridianListView()
        case .symptoms: MacSymptomFinderView()
        case .sessions: MacSessionHistoryView()
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
        .navigationSplitViewColumnWidth(min: 180, ideal: 220)
        .navigationTitle("Dose")
        .navigationDestination(for: SidebarItem.self) { item in
            item.destination
        }
    }
}
