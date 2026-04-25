import Foundation
import SwiftUI

enum AIProvider: String, CaseIterable, Codable, Identifiable {
    case claude = "claude"
    case chatgpt = "chatgpt"
    case gemini = "gemini"
    case custom = "custom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .claude: "Claude"
        case .chatgpt: "ChatGPT"
        case .gemini: "Gemini"
        case .custom: "Custom"
        }
    }

    var color: Color {
        switch self {
        case .claude: Color(red: 0.85, green: 0.47, blue: 0.02)
        case .chatgpt: Color(red: 0.06, green: 0.64, blue: 0.50)
        case .gemini: Color(red: 0.26, green: 0.52, blue: 0.96)
        case .custom: Color(red: 0.55, green: 0.36, blue: 0.96)
        }
    }

    var icon: String {
        switch self {
        case .claude: "sparkles"
        case .chatgpt: "bubble.left.and.bubble.right"
        case .gemini: "diamond"
        case .custom: "cpu"
        }
    }
}

struct UsageEntry: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var provider: AIProvider
    var date: Date
    var conversations: Int
    var tokensEstimate: Int
    var costEstimate: Double
    var model: String
    var notes: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        provider: AIProvider = .claude,
        date: Date = Date(),
        conversations: Int = 0,
        tokensEstimate: Int = 0,
        costEstimate: Double = 0,
        model: String = "",
        notes: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.provider = provider
        self.date = date
        self.conversations = conversations
        self.tokensEstimate = tokensEstimate
        self.costEstimate = costEstimate
        self.model = model
        self.notes = notes
        self.createdAt = createdAt
    }
}

struct UsageSettings: Codable, Equatable {
    var claudeMonthly: Double = 136.60
    var chatgptMonthly: Double = 27.00
    var geminiMonthly: Double = 0
    var currency: String = "CAD"
    var defaultProvider: AIProvider = .claude
}
