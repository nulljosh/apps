import SwiftUI

enum Theme {
    static let accent   = Color(red: 0.000, green: 0.443, blue: 0.890) // #0071e3
    static let green    = Color(red: 0.188, green: 0.820, blue: 0.345) // #30d158
    static let yellow   = Color(red: 1.000, green: 0.839, blue: 0.039) // #ffd60a
    static let orange   = Color(red: 1.000, green: 0.624, blue: 0.039) // #ff9f0a
    static let red      = Color(red: 1.000, green: 0.271, blue: 0.227) // #ff453a
    static let pink     = Color(red: 1.000, green: 0.216, blue: 0.373) // #ff375f
    static let cyan     = Color(red: 0.392, green: 0.820, blue: 1.000) // #64d2ff
    static let bg       = Color(red: 0.039, green: 0.039, blue: 0.047) // #0a0a0c
    static let text1    = Color.white.opacity(0.92)
    static let text2    = Color.white.opacity(0.55)
    static let text3    = Color.white.opacity(0.35)
    static let glass    = Color.white.opacity(0.08)
    static let border   = Color.white.opacity(0.18)
    static let radius: CGFloat = 8
    static let radiusLg: CGFloat = 12
    static let radiusPill: CGFloat = 100

    static func vitalColor(_ value: Double) -> Color {
        value > 60 ? green : value > 30 ? yellow : red
    }
}

struct ResourceMeta {
    let icon: String
    let label: String
    let color: Color
}

let resourceMeta: [ResourceType: ResourceMeta] = [
    .food:      ResourceMeta(icon: "hexagon",    label: "FOOD", color: Theme.green),
    .power:     ResourceMeta(icon: "diamond",    label: "PWR",  color: Theme.yellow),
    .materials: ResourceMeta(icon: "square.fill",label: "MAT",  color: Theme.orange),
    .oxygen:    ResourceMeta(icon: "circle",     label: "O2",   color: Theme.cyan),
    .cash:      ResourceMeta(icon: "dollarsign", label: "CASH", color: Theme.pink),
]

struct GlassPanel<Content: View>: View {
    var cornerRadius: CGFloat = Theme.radius
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            )
    }
}

struct GlassButton: View {
    let label: String
    var isActive: Bool = false
    var isDestructive: Bool = false
    var isPrimary: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(foreColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .frame(minHeight: 36)
                .background(
                    Capsule()
                        .fill(bgColor)
                        .overlay(Capsule().stroke(strokeColor, lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
    }

    private var foreColor: Color {
        if isPrimary { return .white }
        if isDestructive { return Theme.red }
        if isActive { return .white }
        return Theme.text2
    }

    private var bgColor: Color {
        if isPrimary { return Theme.accent }
        if isActive { return Theme.accent.opacity(0.35) }
        return Theme.glass
    }

    private var strokeColor: Color {
        if isPrimary { return .clear }
        if isDestructive { return Theme.red.opacity(0.3) }
        if isActive { return Theme.accent }
        return Theme.border
    }
}
