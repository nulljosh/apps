import SwiftUI

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

enum Theme {
    static let accent = Color(hex: "#ff2d78")
    static let violet = Color(hex: "#8b5cf6")
    static let cyan = Color(hex: "#06b6d4")
    static let green = Color(hex: "#10b981")
    static let amber = Color(hex: "#f59e0b")

    static var bg: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(red: 0.039, green: 0.039, blue: 0.059, alpha: 1)
                : NSColor(red: 0.973, green: 0.973, blue: 0.988, alpha: 1)
        })
    }

    static var card: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(red: 0.086, green: 0.086, blue: 0.122, alpha: 1)
                : NSColor.white
        })
    }

    static var textSecondary: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(red: 0.616, green: 0.616, blue: 0.69, alpha: 1)
                : NSColor(red: 0.333, green: 0.333, blue: 0.416, alpha: 1)
        })
    }

    static var textMuted: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(red: 0.353, green: 0.353, blue: 0.439, alpha: 1)
                : NSColor(red: 0.533, green: 0.533, blue: 0.627, alpha: 1)
        })
    }

    static var border: Color {
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(white: 1, alpha: 0.06)
                : NSColor(white: 0, alpha: 0.06)
        })
    }

    static func colorFromHex(_ hex: String) -> Color {
        Color(hex: hex)
    }
}
