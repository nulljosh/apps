import Foundation

enum DifficultyRank: String, Codable, CaseIterable, Identifiable {
    case F, D, C, B, A, S

    var id: String { rawValue }

    var xpReward: Int {
        switch self {
        case .F: 10
        case .D: 25
        case .C: 50
        case .B: 100
        case .A: 200
        case .S: 500
        }
    }

    var displayColor: String {
        switch self {
        case .F: "gray"
        case .D: "green"
        case .C: "green"
        case .B: "gold"
        case .A: "red"
        case .S: "darkRed"
        }
    }
}

enum QuestCategory: String, Codable, CaseIterable, Identifiable {
    case fitness, study, work, personal, creative, errand

    var id: String { rawValue }

    var label: String {
        rawValue.capitalized
    }

    var className: String {
        switch self {
        case .fitness: "Warrior"
        case .study: "Mage"
        case .work: "Rogue"
        case .personal: "Ranger"
        case .creative: "Bard"
        case .errand: "Merchant"
        }
    }
}

let levelTitles = ["Squire", "Knight", "Champion", "Hero", "Legend", "Mythic"]
