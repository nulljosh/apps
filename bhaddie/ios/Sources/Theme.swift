import SwiftUI

enum Theme {
    static let accent = Color(hex: "#ff2d78")
    static let violet = Color(hex: "#8b5cf6")
    static let cyan = Color(hex: "#06b6d4")
    static let green = Color(hex: "#10b981")
    static let amber = Color(hex: "#f59e0b")

    static let darkBg = Color(hex: "#0a0a0f")
    static let darkCard = Color(hex: "#16161f")

    static let lightBg = Color(hex: "#f8f8fc")
    static let lightCard = Color.white

    static var cardBackground: Color {
        Color(.systemBackground).opacity(0.95)
    }

    static var elevatedBackground: Color {
        Color(.secondarySystemBackground)
    }

    static var mutedText: Color {
        Color(.tertiaryLabel)
    }

    static var secondaryText: Color {
        Color(.secondaryLabel)
    }
}
