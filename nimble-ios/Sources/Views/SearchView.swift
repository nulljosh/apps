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
                            .onSubmit { state.submitQuery() }
                            .onChange(of: state.queryText) { state.scheduleSearch() }

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
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                    // Instant result — tappable
                    if state.result != .none && state.result != .loading {
                        NavigationLink {
                            ResultDetailView(result: state.result)
                        } label: {
                            ResultView()
                                .environment(state)
                                .padding(.horizontal, 16)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 12)
                    }

                    // Web results
                    if !state.webResults.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("WEB")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.tertiary)
                                .tracking(1.2)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)

                            ForEach(state.webResults) { r in
                                Button(action: {
                                    if let url = URL(string: r.url) {
                                        state.safariURL = url
                                    }
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
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .buttonStyle(.plain)

                                if r.id != state.webResults.last?.id {
                                    Divider().padding(.leading, 16)
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.separator), lineWidth: 0.5))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
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
            .sheet(item: $state.safariURL) { url in
                SafariView(url: url).ignoresSafeArea()
            }
        }
        .tint(state.theme.color)
    }
}
