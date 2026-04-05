import SwiftUI

enum QuestTheme {
    // Leather
    static let leatherDark = Color(red: 0.10, green: 0.06, blue: 0.03)
    static let leather = Color(red: 0.18, green: 0.11, blue: 0.05)
    static let leatherLight = Color(red: 0.24, green: 0.17, blue: 0.12)

    // Parchment
    static let parchment = Color(red: 0.96, green: 0.89, blue: 0.76)
    static let parchmentMid = Color(red: 0.91, green: 0.84, blue: 0.64)
    static let parchmentDark = Color(red: 0.83, green: 0.72, blue: 0.59)

    // Ink
    static let ink = Color(red: 0.11, green: 0.07, blue: 0.03)
    static let inkMuted = Color(red: 0.35, green: 0.29, blue: 0.20)

    // Gold
    static let gold = Color(red: 0.79, green: 0.66, blue: 0.30)
    static let goldLight = Color(red: 0.90, green: 0.79, blue: 0.48)
    static let goldDark = Color(red: 0.55, green: 0.41, blue: 0.08)

    // Wax
    static let waxRed = Color(red: 0.55, green: 0.10, blue: 0.10)
    static let waxRedLight = Color(red: 0.75, green: 0.22, blue: 0.17)

    // Green
    static let agedGreen = Color(red: 0.29, green: 0.40, blue: 0.25)

    // Fonts
    static let headingFont = Font.custom("Georgia", size: 22).bold()
    static let bodyFont = Font.custom("Georgia", size: 16)
    static let statsFont = Font.system(size: 14, weight: .semibold, design: .serif)
    static let labelFont = Font.system(size: 11, weight: .medium, design: .serif)
}
