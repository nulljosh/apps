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

@MainActor
struct PortfolioAPI {
    static let baseURL = "https://heyitsmejosh.com"

    static func fetchPage(path: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw PortfolioAPIError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else {
                throw PortfolioAPIError.decodingError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode HTML"]))
            }
            return html
        } catch let error as PortfolioAPIError {
            throw error
        } catch {
            throw PortfolioAPIError.networkError(error)
        }
    }
}
