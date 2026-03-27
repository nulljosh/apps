import SwiftUI
import WebKit

struct ContentView: View {
    @State private var viewModel = PortfolioViewModel()
    @State private var selectedTab: Tab = .projects

    enum Tab: String, CaseIterable {
        case projects = "Projects"
        case site = "Site"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                picker
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                switch selectedTab {
                case .projects:
                    projectsList
                case .site:
                    PortfolioWebView(url: URL(string: "https://heyitsmejosh.com")!)
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadProjects()
            }
        }
    }

    private var picker: some View {
        Picker("View", selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    private var projectsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.projects) { project in
                    ProjectCardView(project: project)
                }
            }
            .padding(16)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView("Failed to Load", systemImage: "wifi.slash", description: Text(error))
            }
        }
    }
}
