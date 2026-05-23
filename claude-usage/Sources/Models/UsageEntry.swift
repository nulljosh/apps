import Foundation

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

    var accentColor: String {
        switch self {
        case .claude: "#D97706"
        case .chatgpt: "#10A37F"
        case .gemini: "#4285F4"
        case .custom: "#8B5CF6"
        }
    }
}

struct UsageEntry: Identifiable, Codable, Equatable {
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
