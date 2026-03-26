import SwiftUI

struct SearchView: View {
    @Environment(AppState.self) private var state
    @FocusState private var isInputFocused: Bool

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .light))
                        .foregroundStyle(.secondary)

                    TextField(state.currentPlaceholder, text: $state.queryText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 20, weight: .light))
                        .focused($isInputFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .onSubmit { state.performQuery() }

                    if state.result == .loading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(width: 20, height: 20)
                    } else if !state.queryText.isEmpty {
                        Button(action: {
                            state.queryText = ""
                            state.result = .none
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Results
                if state.result != .none && state.result != .loading {
                    ScrollView {
                        ResultView()
                            .environment(state)
                    }

                    // Source attribution + actions
                    HStack(spacing: 16) {
                        Button(action: { state.copyResultText() }) {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.system(size: 13))
                        }
                        .tint(state.theme.color)

                        Button(action: { state.openInDDG() }) {
                            Label("Search", systemImage: "safari")
                                .font(.system(size: 13))
                        }
                        .tint(state.theme.color)

                        Spacer()

                        Text(sourceText)
                            .font(.system(size: 12))
                            .foregroundStyle(.tertiary)
                            .onTapGesture { state.openSourceURL() }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground).opacity(0.5))
                } else if state.result == .loading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    }
                    .frame(maxHeight: 200)
                }

                Spacer()
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
