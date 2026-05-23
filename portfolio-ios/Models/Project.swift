import SwiftUI

struct Project: Identifiable {
    let id: String
    let name: String
    let summary: String
    let tags: [String]
    let version: String?
    let urlString: String?
    let iconSystemName: String

    var url: URL? {
        urlString.flatMap { URL(string: $0) }
    }

    var accentColor: Color {
        switch tags.first {
        case "web": .blue
        case "ios": .green
        case "systems": .orange
        case "ai": .purple
        default: .primary
        }
    }
}
