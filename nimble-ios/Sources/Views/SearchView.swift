import SwiftUI

struct SearchView: View {
    @Environment(AppState.self) private var state
    @FocusState private var isInputFocused: Bool

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Search bar — transparent, accent icon, bottom divider
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(state.theme.color)

                        TextField(state.currentPlaceholder, text: $state.queryText)
                            .textFieldStyle(.plain)
                            .font(.system(size: 20, weight: .light))
                            .focused($isInputFocused)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.search)
                            .onSubmit { state.submitQuery() }
                            .onChange(of: state.queryText) { state.scheduleSearch() }

                        if state.result == .loading {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else if !state.queryText.isEmpty {
                            Button(action: {
                                state.queryText = ""
                                state.result = .none
                                state.webResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 13)

                    Divider().opacity(0.4)

                    // History when idle
                    if state.queryText.isEmpty && !state.history.isEmpty {
                        historySection
                    }

                    // Loading shimmer
                    if state.result == .loading {
                        LoadingSkeletonView()
                        Divider().padding(.horizontal, 18).opacity(0.3)
                    }

                    // Instant result
                    if state.result != .none && state.result != .loading {
                        NavigationLink {
                            ResultDetailView(result: state.result)
                        } label: {
                            ResultView()
                                .environment(state)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        // Source footer
                        if let src = sourceText {
                            HStack {
                                Spacer()
                                Text(src)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.tertiary)
                                    .onTapGesture { state.openSourceURL() }
                            }
                            .padding(.horizontal, 18)
                            .padding(.bottom, 6)
                        }

                        Divider().padding(.horizontal, 18).opacity(0.3)
                    }

                    // Web results
                    if !state.webResults.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("WEB")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.tertiary)
                                .tracking(1.2)
                                .padding(.horizontal, 18)
                                .padding(.top, 14)
                                .padding(.bottom, 8)

                            ForEach(state.webResults) { r in
                                Button(action: {
                                    if let url = URL(string: r.url) { state.safariURL = url }
                                }) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(r.domain)
                                            .font(.system(size: 11))
                                            .foregroundStyle(state.theme.color)
                                        Text(r.title)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(.primary)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                        if !r.snippet.isEmpty {
                                            Text(r.snippet)
                                                .font(.system(size: 12))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 12)
                                }
                                .buttonStyle(.plain)

                                if r.id != state.webResults.last?.id {
                                    Divider().padding(.leading, 18)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .background(state.theme.backgroundColor)
            .navigationTitle("Nimble")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { state.showSettings = true }) {
                        Image(systemName: "gear")
                            .foregroundStyle(state.theme.color)
                    }
                }
            }
            .sheet(isPresented: $state.showSettings) {
                SettingsView().environment(state)
            }
            .sheet(item: $state.safariURL) { url in
                SafariView(url: url).ignoresSafeArea()
            }
            .onAppear { isInputFocused = true }
        }
        .tint(state.theme.color)
    }

    @ViewBuilder
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("RECENT")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.tertiary)
                .tracking(1.0)
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 6)

            ForEach(Array(state.history.enumerated()), id: \.element.id) { i, entry in
                Button(action: {
                    state.queryText = entry.query
                    state.submitQuery()
                }) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(historyDotColor(entry.type))
                            .frame(width: 5, height: 5)
                        Text(entry.query)
                            .font(.system(size: 13))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        Spacer()
                        Text(entry.preview)
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if i < state.history.count - 1 {
                    Divider().padding(.leading, 35).opacity(0.4)
                }
            }
        }
    }

    private func historyDotColor(_ type: String) -> Color {
        switch type {
        case "math":    return Color(red: 0.96, green: 0.78, blue: 0.0)
        case "text":    return Color(red: 0.46, green: 0.75, blue: 0.13)
        case "convert": return Color(red: 0.16, green: 0.49, blue: 0.91)
        case "color":   return Color(red: 0.82, green: 0.02, blue: 0.63)
        default:        return .secondary
        }
    }

    private var sourceText: String? {
        switch state.result {
        case .math: return "mathjs"
        case .text(_, _, let source, _, _): return source
        case .list(_, let source): return source
        default: return nil
        }
    }
}
