import Foundation
import SwiftUI

/// Persists user progress to UserDefaults. Uses @Observable for SwiftUI reactivity.
@Observable
final class ProgressManager {

    private static let progressKey = "lingo.progress"

    var progress: UserProgress

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.progressKey),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.progress = decoded
        } else {
            self.progress = UserProgress()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: Self.progressKey)
        }
    }

    func addXP(_ amount: Int) {
        progress.xp += amount
        save()
    }

    func loseHeart() {
        progress.hearts = max(0, progress.hearts - 1)
        save()
    }

    func resetHearts() {
        progress.hearts = 5
        save()
    }

    func markSubjectCompleted(_ subjectId: String) {
        if !progress.completedSubjects.contains(subjectId) {
            progress.completedSubjects.append(subjectId)
            save()
        }
    }

    /// Updates streak based on last played date. Call at end of each lesson.
    func updateStreak() {
        let today = Self.todayString()
        if progress.lastPlayed != today {
            if progress.lastPlayed.isEmpty {
                progress.streak += 1
            } else {
                let diff = Self.daysBetween(progress.lastPlayed, today)
                progress.streak = diff > 1 ? 1 : progress.streak + 1
            }
            progress.lastPlayed = today
        }
        save()
    }

    func resetProgress() {
        progress = UserProgress()
        save()
    }

    // MARK: - Achievements

    func checkAndAwardTrophies(correctAnswers: Int, totalQuestions: Int) {
        let trophies = progress.trophyIds

        if !progress.completedSubjects.isEmpty && !trophies.contains("firstLesson") {
            progress.trophyIds.append("firstLesson")
        }
        if correctAnswers == totalQuestions && !trophies.contains("perfectLesson") {
            progress.trophyIds.append("perfectLesson")
        }
        if progress.streak >= 3 && !trophies.contains("streak3") {
            progress.trophyIds.append("streak3")
        }
        if progress.streak >= 7 && !trophies.contains("streak7") {
            progress.trophyIds.append("streak7")
        }
        if progress.streak >= 30 && !trophies.contains("streak30") {
            progress.trophyIds.append("streak30")
        }
        if progress.xp >= 100 && !trophies.contains("xp100") {
            progress.trophyIds.append("xp100")
        }
        if progress.xp >= 500 && !trophies.contains("xp500") {
            progress.trophyIds.append("xp500")
        }
        if progress.xp >= 1000 && !trophies.contains("xp1000") {
            progress.trophyIds.append("xp1000")
        }

        let langCount = progress.completedSubjects.filter {
            QuestionBank.languageSubjectIds.contains($0)
        }.count
        if langCount >= 3 && !trophies.contains("polyglot") {
            progress.trophyIds.append("polyglot")
        }

        let mathComplete = QuestionBank.mathSubjectIds.allSatisfy {
            progress.completedSubjects.contains($0)
        }
        if mathComplete && !trophies.contains("mathWiz") {
            progress.trophyIds.append("mathWiz")
        }

        if progress.completedSubjects.count >= 10 && !trophies.contains("explorer") {
            progress.trophyIds.append("explorer")
        }

        save()
    }

    // MARK: - Helpers

    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: Date())
    }

    static func daysBetween(_ from: String, _ to: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        guard let d1 = formatter.date(from: from),
              let d2 = formatter.date(from: to) else { return 999 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: d1, to: d2)
        return abs(components.day ?? 999)
    }
}
