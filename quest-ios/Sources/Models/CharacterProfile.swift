import Foundation
import SwiftData

@Model
final class CharacterProfile {
    var id: UUID
    var name: String
    var totalXP: Int
    var currentStreak: Int
    var lastActiveDate: Date?

    var level: Int { XPEngine.getLevel(totalXP) }
    var title: String { XPEngine.getTitle(level) }

    init(name: String = "Adventurer") {
        self.id = UUID()
        self.name = name
        self.totalXP = 0
        self.currentStreak = 0
        self.lastActiveDate = nil
    }

    func addXP(_ amount: Int) {
        totalXP += amount
    }

    func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        guard let last = lastActiveDate else {
            currentStreak = 1
            lastActiveDate = today
            return
        }
        let lastDay = Calendar.current.startOfDay(for: last)
        if lastDay == today { return }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        currentStreak = (lastDay == yesterday) ? currentStreak + 1 : 1
        lastActiveDate = today
    }
}
