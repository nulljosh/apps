import Foundation

struct Post: Identifiable, Hashable {
    let id: String
    let title: String
    let url: URL?
    let published: Date?
    let contentHTML: String

    var displayDate: String {
        guard let published else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: published)
    }

    /// Plain-text preview pulled from the HTML body, used in the list row.
    var excerpt: String {
        let stripped = contentHTML
            .replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "&[^;]+;", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return String(stripped.prefix(160))
    }
}
