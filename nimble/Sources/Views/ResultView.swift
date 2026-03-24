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
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 28, weight: .medium, design: .monospaced))
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

        case .text(let heading, let body, _, _, let imageURL):
            ScrollView {
                HStack(alignment: .top, spacing: 14) {
                    if let imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            default:
                                EmptyView()
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        if let heading, !heading.isEmpty {
                            Text(heading)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.primary)
                        }

                        Text(body)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                            .lineSpacing(3)
                            .lineLimit(nil)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .frame(maxHeight: 300)

        case .list(let items, _):
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 10) {
                            Text("\(index + 1)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.tertiary)
                                .frame(width: 20)
                            Text(item)
                                .font(.system(size: 13))
                                .foregroundStyle(.primary)
                                .textSelection(.enabled)
                                .lineLimit(2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)

                        if index < items.count - 1 {
                            Divider()
                                .padding(.leading, 50)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(maxHeight: 300)

        case .error(let message, let searchURL):
            VStack(spacing: 6) {
                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                if let searchURL, let url = URL(string: searchURL) {
                    Button("Search on DuckDuckGo") {
                        NSWorkspace.shared.open(url)
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.blue)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
    }
}
