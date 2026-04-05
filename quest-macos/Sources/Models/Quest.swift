import Foundation
import SwiftData

@Model
final class Quest {
    var id: UUID
    var title: String
    var difficulty: DifficultyRank
    var category: QuestCategory
    var notes: String
    var dueDate: Date?
    var completed: Bool
    var completedAt: Date?
    var createdAt: Date

    var xpReward: Int { difficulty.xpReward }

    init(
        title: String,
        difficulty: DifficultyRank = .C,
        category: QuestCategory = .personal,
        notes: String = "",
        dueDate: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.difficulty = difficulty
        self.category = category
        self.notes = notes
        self.dueDate = dueDate
        self.completed = false
        self.completedAt = nil
        self.createdAt = Date()
    }
}
