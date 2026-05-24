import SwiftUI

struct ValueBeltView: View {
    @Environment(Store.self) private var store

    private struct Col {
        let label: String; let value: String; let sub: String; let highlight: Bool
    }

    private var cols: [Col] {
        switch store.activeCase {
        case .rcmp:
            return [
                Col(label: "Floor",              value: "$317k",       sub: "Degen 2023 BCSC · force + PTSD",       highlight: false),
                Col(label: "Today's projection", value: "$800k–$1.2M", sub: "leverage based on evidence + counsel", highlight: true),
                Col(label: "Trial ceiling",       value: "$2.25M",     sub: "Ward maxed · punitive granted",        highlight: false)
            ]
        case .family:
            return [
                Col(label: "Floor",         value: "$100k",       sub: "Likeness claim only · minimum",       highlight: false),
                Col(label: "Most likely",   value: "$300k–600k",  sub: "Likeness + recent IIMS survive",      highlight: true),
                Col(label: "Trial ceiling", value: "$1.5M+",      sub: "All heads · punitive granted",        highlight: false)
            ]
        case .muni:
            return [
                Col(label: "Floor",              value: "$5.5k",   sub: "Minor injury cap · pain/suffering",   highlight: false),
                Col(label: "Most likely",        value: "$8k–12k", sub: "Medical + wages + cap",              highlight: true),
                Col(label: "Ceiling (fracture)", value: "$40k+",   sub: "If bone injury discovered",          highlight: false)
            ]
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(cols.enumerated()), id: \.offset) { i, col in
                if i > 0 { Divider() }
                VStack(alignment: .leading, spacing: 4) {
                    Text(col.label.uppercased())
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .tracking(1.5)
                        .foregroundStyle(.secondary)
                    Text(col.value)
                        .font(.system(size: 20, weight: .bold))
                        .monospacedDigit()
                        .foregroundStyle(col.highlight ? Color.primary : Color.secondary)
                    Text(col.sub)
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(.tertiary)
                        .lineSpacing(1.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}
