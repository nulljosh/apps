import SwiftUI

struct SidebarView: View {
    @Environment(UsageStore.self) private var store

    var body: some View {
        @Bindable var store = store

        List(selection: $store.selectedTab) {
            Section("Overview") {
                ForEach(UsageStore.Tab.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: iconFor(tab))
                        .tag(tab)
                }
            }

            Section("Filter by Provider") {
                Label("All Providers", systemImage: "square.stack.3d.up")
                    .tag(Optional<AIProvider>.none)
                    .foregroundStyle(store.selectedProvider == nil ? .accentColor : .primary)
                    .onTapGesture { store.selectedProvider = nil }

                ForEach(AIProvider.allCases) { provider in
                    HStack {
                        Circle()
                            .fill(providerColor(provider))
                            .frame(width: 8, height: 8)
                        Text(provider.displayName)
                    }
                    .contentShape(Rectangle())
                    .foregroundStyle(store.selectedProvider == provider ? .accentColor : .primary)
                    .onTapGesture { store.selectedProvider = provider }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Claude Usage")
        .toolbar {
            ToolbarItem {
                Button(action: { store.showingAddEntry = true }) {
                    Label("Add Entry", systemImage: "plus")
                }
            }
        }
    }

    private func iconFor(_ tab: UsageStore.Tab) -> String {
        switch tab {
        case .dashboard: "chart.bar.fill"
        case .entries: "list.bullet.rectangle"
        case .charts: "chart.line.uptrend.xyaxis"
        }
    }

    private func providerColor(_ provider: AIProvider) -> Color {
        switch provider {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }
}
