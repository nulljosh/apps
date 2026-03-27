import SwiftUI

@MainActor
@Observable
final class PortfolioViewModel {
    var projects: [Project] = []
    var isLoading = false
    var errorMessage: String?

    func loadProjects() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        // Static project data matching heyitsmejosh.com
        projects = [
            Project(id: "opticon", name: "Monica", summary: "Personal intelligence platform. Financial terminal, prediction markets, news mapping, portfolio tracking.", tags: ["web", "ios"], version: "5.0.0", urlString: "https://opticon.heyitsmejosh.com", iconSystemName: "chart.line.uptrend.xyaxis"),
            Project(id: "tally", name: "Tally", summary: "BC Self-Serve scraper and benefits guide. Session cookie auth, Vercel Blob cache.", tags: ["web", "ios"], version: nil, urlString: "https://tally.heyitsmejosh.com", iconSystemName: "doc.text.magnifyingglass"),
            Project(id: "dose", name: "Dose", summary: "Health tracker with 200+ substances, daily check-ins, biometrics, HealthKit sync.", tags: ["web", "ios"], version: nil, urlString: "https://dose.heyitsmejosh.com", iconSystemName: "pills.fill"),
            Project(id: "spark", name: "Spark", summary: "Idea-sharing platform with auth, posts, voting. Supabase backend.", tags: ["web", "ios"], version: nil, urlString: "https://spark.heyitsmejosh.com", iconSystemName: "lightbulb.fill"),
            Project(id: "systems", name: "Systems", summary: "Low-level systems monorepo: C compiler (ARM64), OS kernel, shell, debugger, profiler, KV store.", tags: ["systems"], version: nil, urlString: "https://github.com/nulljosh/systems", iconSystemName: "cpu"),
            Project(id: "apps", name: "Apps", summary: "Small standalone apps monorepo: browser, nimble, nyc, rabbit, lingo, roost, and more.", tags: ["ios", "web"], version: nil, urlString: "https://github.com/nulljosh/apps", iconSystemName: "square.grid.2x2"),
            Project(id: "journal", name: "Journal", summary: "Personal blog. Jekyll, GitHub Pages.", tags: ["web"], version: nil, urlString: "https://journal.heyitsmejosh.com", iconSystemName: "book.fill"),
            Project(id: "arthur", name: "Arthur", summary: "Custom 65M-param language model. PyTorch training, C99 inference, MoE architecture.", tags: ["ai"], version: nil, urlString: "https://github.com/nulljosh/arthur", iconSystemName: "brain"),
            Project(id: "bots", name: "Bots", summary: "AI automation bots: phone calls (fony), food ordering, strain tracker.", tags: ["ai"], version: nil, urlString: nil, iconSystemName: "robot"),
        ]
    }
}
