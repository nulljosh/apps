import Foundation

struct UserProgress: Codable, Equatable {
    var xp: Int = 0
    var streak: Int = 0
    var hearts: Int = 5
    var completedSubjects: [String] = []
    var trophyIds: [String] = []
    var lastPlayed: String = ""
}
