import SwiftUI

struct ResultView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        switch state.result {
        case .none, .loading:
            EmptyView()

        case .math(let value):
            VStack(spacing: 6) {
                Text(value)
                    .font(.system(size: 36, weight: .semibold, design: .monospaced))
                    .foregroundStyle(state.theme.color)
                    .textSelection(.enabled)

                Text("RESULT")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .tracking(1.2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

        case .text(let heading, let body, _, _, let imageURL):
            VStack(alignment: .leading, spacing: 10) {
                if let imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 72, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        default:
                            EmptyView()
                        }
                    }
                }

                if let heading, !heading.isEmpty {
                    Text(heading)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(state.theme.textColor)
                }

                Text(body)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
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
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundStyle(.tertiary)
                            .frame(width: 22)
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundStyle(state.theme.textColor)
                            .textSelection(.enabled)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)

                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))

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
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
