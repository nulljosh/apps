import SwiftUI

struct ResultView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        switch state.result {
        case .none, .loading:
            EmptyView()

        case .math(let value):
            MathResultView(value: value, accent: state.theme.color)

        case .text(let heading, let body, _, _, let imageURL):
            HStack(alignment: .top, spacing: 14) {
                if let imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        if case .success(let image) = phase {
                            image.resizable().aspectRatio(contentMode: .fill)
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .opacity(0.9)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    if let heading, !heading.isEmpty {
                        Text(heading)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(state.theme.textColor)
                    }
                    Text(body)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case .list(let items, _):
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(state.theme.color.opacity(0.7))
                            .frame(width: 18)
                        Text(item)
                            .font(.system(size: 13))
                            .foregroundStyle(state.theme.textColor)
                            .textSelection(.enabled)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    if index < items.count - 1 {
                        Divider().padding(.leading, 46).opacity(0.4)
                    }
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case .color(let hex):
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: hex) ?? state.theme.color)
                    .frame(width: 56, height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                VStack(alignment: .leading, spacing: 6) {
                    Text("HEX  \(hex.uppercased())").font(.system(size: 12)).foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case .convert(let from, let to, let fromUnit, let toUnit):
            HStack(spacing: 20) {
                VStack(spacing: 2) {
                    Text(from).font(.system(size: 28, weight: .light)).foregroundStyle(Color.primary.opacity(0.5))
                    Text(fromUnit).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Text("→").font(.system(size: 16)).foregroundStyle(state.theme.color.opacity(0.5))
                VStack(spacing: 2) {
                    Text(to).font(.system(size: 36, weight: .semibold)).foregroundStyle(state.theme.textColor)
                    Text(toUnit).font(.system(size: 11)).foregroundStyle(state.theme.color.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case .error(let message, let searchURL):
            VStack(spacing: 10) {
                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                if let searchURL, let url = URL(string: searchURL) {
                    Button("Search on DuckDuckGo") { UIApplication.shared.open(url) }
                        .font(.system(size: 13, weight: .medium))
                        .tint(state.theme.color)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

private struct MathResultView: View {
    let value: String
    let accent: Color
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(accent)
                .textSelection(.enabled)
            Text("RESULT")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.tertiary)
                .tracking(1.2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .scaleEffect(appeared ? 1.0 : 0.88)
        .opacity(appeared ? 1.0 : 0)
        .onAppear { withAnimation(.spring(duration: 0.35, bounce: 0.4)) { appeared = true } }
    }
}

private extension Color {
    init?(hex: String) {
        let h = hex.replacingOccurrences(of: "#", with: "")
        guard let v = Int(h, radix: 16) else { return nil }
        self.init(red: Double((v >> 16) & 0xFF) / 255, green: Double((v >> 8) & 0xFF) / 255, blue: Double(v & 0xFF) / 255)
    }
}
