import SwiftUI

struct ResultView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        switch state.result {
        case .none, .loading:
            EmptyView()

        case .math(let value):
            HStack {
                Text("=")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 32, weight: .medium, design: .monospaced))
                    .foregroundStyle(state.theme.textColor)
                    .textSelection(.enabled)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        case .text(let heading, let body, _, _, let imageURL):
            VStack(alignment: .leading, spacing: 12) {
                if let imageURL, let url = URL(string: imageURL) {
                    HStack {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            default:
                                EmptyView()
                            }
                        }
                        Spacer()
                    }
                }

                if let heading, !heading.isEmpty {
                    Text(heading)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(state.theme.textColor)
                }

                Text(body)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        case .list(let items, _):
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundStyle(.tertiary)
                            .frame(width: 24)
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundStyle(state.theme.textColor)
                            .textSelection(.enabled)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)

                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }

        case .error(let message, let searchURL):
            VStack(spacing: 10) {
                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                if let searchURL, let url = URL(string: searchURL) {
                    Button("Search on DuckDuckGo") {
                        UIApplication.shared.open(url)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .tint(state.theme.color)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
        }
    }
}
