import Foundation

enum XPEngine {
    static func getLevel(_ totalXP: Int) -> Int {
        Int(floor(sqrt(Double(totalXP) / 50.0)))
    }

    static func getTitle(_ level: Int) -> String {
        let index = min(max(level, 0), levelTitles.count - 1)
        return levelTitles[index]
    }

    static func xpForNextLevel(_ currentLevel: Int) -> Int {
        let next = currentLevel + 1
        return next * next * 50
    }

    static func xpProgress(_ totalXP: Int) -> (level: Int, progress: Int, needed: Int, percent: Double) {
        let level = getLevel(totalXP)
        let currentThreshold = level * level * 50
        let nextThreshold = (level + 1) * (level + 1) * 50
        let progress = totalXP - currentThreshold
        let needed = nextThreshold - currentThreshold
        let percent = needed > 0 ? Double(progress) / Double(needed) * 100.0 : 0
        return (level, progress, needed, percent)
    }
}
