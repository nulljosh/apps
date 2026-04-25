import SwiftUI
import WebKit

struct ContentView: View {
    @State private var viewModel = PortfolioViewModel()
    @State private var selectedTab: Tab = .projects

    enum Tab: String, CaseIterable {
        case projects = "Projects"
        case contributions = "Activity"
        case site = "Site"
    }

    var body: some View {
        #if os(macOS)
        macLayout
        #else
        iosLayout
        #endif
    }

    // MARK: - iOS

    private var iosLayout: some View {
        NavigationStack {
            VStack(spacing: 0) {
                picker
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                switch selectedTab {
                case .projects:
                    projectsList
                case .contributions:
                    contributionsTab
                case .site:
                    PortfolioWebView(url: URL(string: "https://heyitsmejosh.com")!)
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.load() }
        }
    }

    // MARK: - macOS

    #if os(macOS)
    private var macLayout: some View {
        NavigationSplitView {
            List(viewModel.projects) { project in
                NavigationLink(value: project) {
                    Label(project.name, systemImage: project.iconSystemName)
                }
            }
            .navigationTitle("Joshua Trommel")
        } detail: {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    if !viewModel.projects.isEmpty {
                        projectGrid
                    }
                    if !viewModel.contributions.isEmpty {
                        contribSection
                    }
                }
                .padding(24)
            }
        }
        .task { await viewModel.load() }
    }

    private var projectGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: 16)], spacing: 16) {
            ForEach(viewModel.projects) { project in
                ProjectCardView(project: project)
            }
        }
    }

    private var contribSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contributions")
                .font(.caption.weight(.medium))
                .foregroundStyle(.tertiary)
                .textCase(.uppercase)
                .tracking(1.5)
            ContributionGridView(
                contributions: viewModel.contributions,
                eventMap: viewModel.eventMap,
                currentStreak: viewModel.currentStreak,
                longestStreak: viewModel.longestStreak,
                total: viewModel.totalContributions
            )
        }
    }
    #endif

    // MARK: - Shared

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

    private var contributionsTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if viewModel.contributions.isEmpty && viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(40)
                } else if viewModel.contributions.isEmpty {
                    ContentUnavailableView("No Data", systemImage: "chart.bar.xaxis")
                        .padding(40)
                } else {
                    ContributionGridView(
                        contributions: viewModel.contributions,
                        eventMap: viewModel.eventMap,
                        currentStreak: viewModel.currentStreak,
                        longestStreak: viewModel.longestStreak,
                        total: viewModel.totalContributions
                    )
                    .padding(16)
                }
            }
        }
    }
}
