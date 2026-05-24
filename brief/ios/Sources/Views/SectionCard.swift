import SwiftUI

struct SectionCard<Content: View>: View {
    let label: String
    let roman: String?
    let hint: String?
    let content: Content

    init(_ label: String, roman: String? = nil, hint: String? = nil, @ViewBuilder content: () -> Content) {
        self.label = label
        self.roman = roman
        self.hint = hint
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                if let roman {
                    Text(roman)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color.briefDanger)
                }
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                if let hint {
                    Spacer()
                    Text(hint)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.tertiary)
                }
            }
            content
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
