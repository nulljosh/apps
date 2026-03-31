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
        case .feet: "figure.walk"
        case .hands: "hand.raised.fingers.spread"
        case .points: "target"
        case .symptoms: "cross.circle"
        case .history: "clock.arrow.trianglehead.counterclockwise.rotate.90"
        }
    }
}
