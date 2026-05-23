import Foundation

enum PortfolioAPIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case .networkError(let error): "Network error: \(error.localizedDescription)"
        case .decodingError(let error): "Decoding error: \(error.localizedDescription)"
        }
    }
}

struct Contribution: Codable, Identifiable {
    let date: String
    let count: Int
    let level: Int
    var id: String { date }
}

struct GitHubEvent: Codable, Identifiable {
    let id: String
    let type: String
    let repo: RepoRef
    let payload: Payload
    let createdAt: String

    var date: String { String(createdAt.prefix(10)) }

    var description: String {
        let name = repo.name.replacingOccurrences(of: "nulljosh/", with: "")
        switch type {
        case "PushEvent":
            let n = payload.commits?.count ?? 1
            return "pushed \(n) commit\(n != 1 ? "s" : "") to \(name)"
        case "PullRequestEvent":
            return "\(payload.action ?? "updated") PR in \(name)"
        case "IssuesEvent":
            return "\(payload.action ?? "updated") issue in \(name)"
        case "CreateEvent":
            return "created \(payload.refType ?? "branch") in \(name)"
        case "ReleaseEvent":
            return "released \(payload.release?.tagName ?? "build") in \(name)"
        case "WatchEvent":
            return "starred \(name)"
        case "ForkEvent":
            return "forked \(name)"
        default:
            return "activity in \(name)"
        }
    }

    struct RepoRef: Codable {
        let name: String
    }

    struct Payload: Codable {
        let action: String?
        let commits: [CommitRef]?
        let refType: String?
        let release: ReleaseRef?

        struct CommitRef: Codable {
            let message: String
        }
        struct ReleaseRef: Codable {
            let tagName: String
            enum CodingKeys: String, CodingKey { case tagName = "tag_name" }
        }
        enum CodingKeys: String, CodingKey {
            case action, commits, release
            case refType = "ref_type"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, type, repo, payload
        case createdAt = "created_at"
    }
}

@MainActor
struct PortfolioAPI {
    static let baseURL = "https://heyitsmejosh.com"

    static func fetchContributions() async throws -> [Contribution] {
        guard let url = URL(string: "https://github-contributions-api.jogruber.de/v4/nulljosh?y=last") else {
            throw PortfolioAPIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        struct Response: Codable { let contributions: [Contribution] }
        do {
            return try JSONDecoder().decode(Response.self, from: data).contributions
        } catch {
            throw PortfolioAPIError.decodingError(error)
        }
    }

    static func fetchEvents() async throws -> [GitHubEvent] {
        var all: [GitHubEvent] = []
        for page in 1...3 {
            guard let url = URL(string: "https://api.github.com/users/nulljosh/events?per_page=100&page=\(page)") else { break }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { break }
            let batch = try JSONDecoder().decode([GitHubEvent].self, from: data)
            if batch.isEmpty { break }
            all.append(contentsOf: batch)
        }
        return all
    }
}
