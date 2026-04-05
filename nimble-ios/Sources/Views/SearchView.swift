import SwiftUI

struct SearchView: View {
    @Environment(AppState.self) private var state
    @FocusState private var isInputFocused: Bool

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.tertiary)

                        TextField(state.currentPlaceholder, text: $state.queryText)
                            .textFieldStyle(.plain)
                            .font(.system(size: 17))
                            .focused($isInputFocused)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .submitLabel(.search)
                            .onSubmit { state.performQuery() }

                        if state.result == .loading {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else if !state.queryText.isEmpty {
                            Button(action: {
                                state.queryText = ""
                                state.result = .none
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                    // Results
                    if state.result != .none && state.result != .loading {
                        VStack(spacing: 10) {
                            ResultView()
                                .environment(state)
                        }
                        .padding(.horizontal, 16)

                        // Actions
                        HStack(spacing: 20) {
                            Button(action: { state.copyResultText() }) {
                                Label("Copy", systemImage: "doc.on.doc")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .tint(state.theme.color)

                            Button(action: { state.openInDDG() }) {
                                Label("Open in Browser", systemImage: "safari")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .tint(state.theme.color)

                            Spacer()

                            Text(sourceText)
                                .font(.system(size: 11))
                                .foregroundStyle(.tertiary)
                                .onTapGesture { state.openSourceURL() }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        .padding(.bottom, 8)
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
                SettingsView()
                    .environment(state)
            }
            .onAppear { isInputFocused = true }
        }
        .tint(state.theme.color)
    }

    private var sourceText: String {
        switch state.result {
        case .math: return "mathjs"
        case .text(_, _, let source, _, _): return source
        case .list(_, let source): return source
        default: return ""
        }
    }
}
