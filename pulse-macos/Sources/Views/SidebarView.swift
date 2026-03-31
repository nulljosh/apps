import SwiftUI

enum SidebarIcon {
    static let feet = "figure.walk"
    static let hands = "hand.raised.fingers.spread"
    static let points = "target"
    static let symptoms = "cross.circle"
    static let history = "clock.arrow.trianglehead.counterclockwise.rotate.90"
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case feet = "Foot Reflexology"
    case hands = "Hand Reflexology"
    case points = "Acupuncture Points"
    case symptoms = "What Hurts?"
    case history = "Session History"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .feet: SidebarIcon.feet
        case .hands: SidebarIcon.hands
        case .points: SidebarIcon.points
        case .symptoms: SidebarIcon.symptoms
        case .history: SidebarIcon.history
        }
    }
}
