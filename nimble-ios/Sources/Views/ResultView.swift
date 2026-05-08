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
                        .lineSpacing(3)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.quaternary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))

        case .list(let items, _):
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.prefix(5).enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(state.theme.color.opacity(0.7))
                            .frame(width: 18)
                        Text(item)
                            .font(.system(size: 13))
                            .foregroundStyle(state.theme.textColor)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    if index < min(items.count, 5) - 1 {
                        Divider().padding(.leading, 46).opacity(0.4)
                    }
                }
                if items.count > 5 {
                    HStack {
                        Spacer()
                        Text("+\(items.count - 5) more")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.quaternary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))

        case .color(let hex):
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: hex) ?? state.theme.color)
                    .frame(width: 52, height: 52)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.separator), lineWidth: 0.5))
                VStack(alignment: .leading, spacing: 4) {
                    Text("#\(hex.uppercased())")
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.primary)
                    Text("Tap for RGB, HSL")
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.quaternary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))

        case .convert(let from, let to, let fromUnit, let toUnit):
            HStack(spacing: 20) {
                VStack(spacing: 2) {
                    Text(from).font(.system(size: 24, weight: .light)).foregroundStyle(Color.primary.opacity(0.4))
                    Text(fromUnit).font(.system(size: 11)).foregroundStyle(.secondary)
                }
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
                    .foregroundStyle(state.theme.color.opacity(0.5))
                VStack(spacing: 2) {
                    Text(to).font(.system(size: 32, weight: .semibold)).foregroundStyle(state.theme.textColor)
                    Text(toUnit).font(.system(size: 11)).foregroundStyle(state.theme.color.opacity(0.7))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.quaternary)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))

        case .error(let message, _):
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(.tertiary)
                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.quaternary)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))
        }
    }
}

private struct MathResultView: View {
    let value: String
    let accent: Color
    @State private var appeared = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(accent)
                    .minimumScaleFactor(0.5)
                Text("RESULT")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.tertiary)
                    .tracking(1.2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.quaternary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))
        .scaleEffect(appeared ? 1.0 : 0.92)
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
