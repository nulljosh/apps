import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var state
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            List {
                // Theme picker
                Section {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                        ForEach(NimbleTheme.allCases, id: \.self) { theme in
                            Button(action: {
                                state.theme = theme
                                state.savePreferences()
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                VStack(spacing: 6) {
                                    Circle()
                                        .fill(theme.color)
                                        .frame(width: 32, height: 32)
                                        .overlay {
                                            if state.theme == theme {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundStyle(theme == .yellow ? .black : .white)
                                            }
                                        }
                                    Text(theme.displayName)
                                        .font(.system(size: 11))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Theme")
                }

                // Preferences
                Section {
                    Toggle("Offline Math", isOn: $state.mathEnabled)
                        .onChange(of: state.mathEnabled) { state.savePreferences() }

                    Toggle("Default Suggestions", isOn: $state.defaultSuggestions)
                        .onChange(of: state.defaultSuggestions) { state.savePreferences() }
                } header: {
                    Text("Preferences")
                }

                // About
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Sources")
                        Spacer()
                        Text("DuckDuckGo + Wikipedia")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 14))
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.medium)
                }
            }
            .tint(state.theme.color)
        }
    }
}
