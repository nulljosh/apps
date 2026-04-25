import SwiftUI

@MainActor
@Observable
final class PortfolioViewModel {
    var projects: [Project] = []
    var contributions: [Contribution] = []
    var eventMap: [String: [GitHubEvent]] = [:]
    var isLoading = false
    var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        loadStaticProjects()

        async let contribTask = PortfolioAPI.fetchContributions()
        async let eventsTask = PortfolioAPI.fetchEvents()

        do {
            let (contribs, events) = try await (contribTask, eventsTask)
            contributions = contribs
            var map: [String: [GitHubEvent]] = [:]
            for ev in events {
                map[ev.date, default: []].append(ev)
            }
            eventMap = map
        } catch {
            // contributions are non-critical — degrade gracefully
            print("Contributions/events fetch failed: \(error)")
        }
    }

    var currentStreak: Int {
        var count = 0
        for c in contributions.reversed() {
            if c.count > 0 { count += 1 } else { break }
        }
        return count
    }

    var longestStreak: Int {
        var longest = 0, run = 0
        for c in contributions {
            run = c.count > 0 ? run + 1 : 0
            longest = max(longest, run)
        }
        return longest
    }

    var totalContributions: Int {
        contributions.reduce(0) { $0 + $1.count }
    }

    private func loadStaticProjects() {
        projects = [
            Project(id: "monica", name: "Monica", summary: "Personal intelligence platform. Markets, macro, news, and daily briefs.", tags: ["web", "ios", "macos"], version: "5.0.0", urlString: "https://monica.heyitsmejosh.com", iconSystemName: "chart.line.uptrend.xyaxis"),
            Project(id: "spark", name: "Spark", summary: "Idea-sharing platform with auth, posts, and voting. Supabase backend.", tags: ["web", "ios"], version: nil, urlString: "https://spark.heyitsmejosh.com", iconSystemName: "lightbulb.fill"),
            Project(id: "tally", name: "Tally", summary: "BC benefits tracker and self-serve scraper.", tags: ["web", "ios"], version: nil, urlString: "https://tally.heyitsmejosh.com", iconSystemName: "doc.text.magnifyingglass"),
            Project(id: "dose", name: "Dose", summary: "Health tracker for drugs, vitamins, and biometrics. 200+ substances, HealthKit sync.", tags: ["ios"], version: nil, urlString: "https://dose.heyitsmejosh.com", iconSystemName: "pills.fill"),
            Project(id: "nimble", name: "Nimble", summary: "Instant answers and web search with mind-map visualization.", tags: ["web", "macos", "ios"], version: nil, urlString: "https://nimble.heyitsmejosh.com", iconSystemName: "magnifyingglass"),
            Project(id: "nyc", name: "NYC", summary: "Times Square Survival. Colony sim with AI colonists, combat, and building placement.", tags: ["web", "macos", "ios"], version: nil, urlString: "https://nyc.heyitsmejosh.com", iconSystemName: "building.2.fill"),
        ]
    }
}
