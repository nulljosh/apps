import SwiftUI

struct SearchView: View {
    @Environment(AppState.self) private var state
    @FocusState private var isInputFocused: Bool

    var body: some View {
        @Bindable var state = state

        VStack(spacing: 0) {
            // Search bar -- Spotlight style
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(.secondary)

                TextField(state.currentPlaceholder, text: $state.queryText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 24, weight: .light))
                    .focused($isInputFocused)
                    .onSubmit { state.performQuery() }
                    .onKeyPress(.tab) {
                        if state.queryText.isEmpty {
                            state.queryText = state.currentPlaceholder
                        }
                        return .handled
                    }

                if state.result == .loading {
                    ProgressView()
                        .scaleEffect(0.7)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            // Results
            if state.result != .none {
                Divider()
                    .padding(.horizontal, 12)

                ResultView()
                    .environment(state)

                // Source attribution
                if state.result != .loading {
                    HStack {
                        Spacer()
                        Text(sourceText)
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                            .onTapGesture { openSource() }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                    .padding(.top, 2)
                }
            }
        }
        .frame(width: 680)
        .fixedSize(horizontal: false, vertical: true)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear { isInputFocused = true }
        .contextMenu {
            ContextMenuView()
                .environment(state)
        }
    }

    private var sourceText: String {
        switch state.result {
        case .math: return "mathjs"
        case .text(_, _, let source, _, _): return source
        case .list(_, let source): return source
        default: return ""
        }
    }

    private func openSource() {
        switch state.result {
        case .text(_, _, _, let url, _):
            if let url, let u = URL(string: url) {
                NSWorkspace.shared.open(u)
            }
        default:
            state.openInDDG()
        }
    }
}
