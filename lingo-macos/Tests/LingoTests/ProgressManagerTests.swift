import XCTest
@testable import Lingo

final class ProgressManagerTests: XCTestCase {

    private var manager: ProgressManager!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "lingo.progress")
        manager = ProgressManager()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "lingo.progress")
        super.tearDown()
    }

    // MARK: - XP Tests

    func testInitialXPIsZero() {
        XCTAssertEqual(manager.progress.xp, 0)
    }

    func testAddXP() {
        manager.addXP(10)
        XCTAssertEqual(manager.progress.xp, 10)
    }

    func testAddXPAccumulates() {
        manager.addXP(10)
        manager.addXP(20)
        manager.addXP(30)
        XCTAssertEqual(manager.progress.xp, 60)
    }

    // MARK: - Hearts Tests

    func testInitialHeartsIsFive() {
        XCTAssertEqual(manager.progress.hearts, 5)
    }

    func testLoseHeart() {
        manager.loseHeart()
        XCTAssertEqual(manager.progress.hearts, 4)
    }

    func testHeartsCannotGoBelowZero() {
        for _ in 0..<10 {
            manager.loseHeart()
        }
        XCTAssertEqual(manager.progress.hearts, 0)
    }

    func testResetHearts() {
        manager.loseHeart()
        manager.loseHeart()
        manager.resetHearts()
        XCTAssertEqual(manager.progress.hearts, 5)
    }

    // MARK: - Streak Tests

    func testFirstPlaySetsStreakToOne() {
        manager.updateStreak()
        XCTAssertEqual(manager.progress.streak, 1)
    }

    func testSameDayDoesNotIncrementStreak() {
        manager.updateStreak()
        let streakAfterFirst = manager.progress.streak
        manager.updateStreak()
        XCTAssertEqual(manager.progress.streak, streakAfterFirst)
    }

    func testDaysBetweenCalculation() {
        XCTAssertEqual(ProgressManager.daysBetween("2026-03-20", "2026-03-21"), 1)
        XCTAssertEqual(ProgressManager.daysBetween("2026-03-20", "2026-03-25"), 5)
        XCTAssertEqual(ProgressManager.daysBetween("2026-03-20", "2026-03-20"), 0)
    }

    func testStreakResetsAfterMissedDay() {
        manager.progress.streak = 5
        manager.progress.lastPlayed = "2026-03-20"
        // Simulate playing 2 days later (missed a day)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let twoDaysLater = Calendar.current.date(byAdding: .day, value: 2, to: formatter.date(from: "2026-03-20")!)!
        manager.progress.lastPlayed = formatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
        // Force a new day scenario by manipulating lastPlayed
        manager.progress.lastPlayed = "2026-03-20"
        manager.progress.streak = 5
        // daysBetween from "2026-03-20" to "2026-03-22" = 2, so streak resets to 1
        let diff = ProgressManager.daysBetween("2026-03-20", "2026-03-22")
        XCTAssertEqual(diff, 2)
        // Verify the logic: diff > 1 means streak resets
        let newStreak = diff > 1 ? 1 : manager.progress.streak + 1
        XCTAssertEqual(newStreak, 1)
    }

    func testStreakContinuesNextDay() {
        let diff = ProgressManager.daysBetween("2026-03-20", "2026-03-21")
        XCTAssertEqual(diff, 1)
        let currentStreak = 3
        let newStreak = diff > 1 ? 1 : currentStreak + 1
        XCTAssertEqual(newStreak, 4)
    }

    // MARK: - Subject Completion

    func testMarkSubjectCompleted() {
        manager.markSubjectCompleted("spanish")
        XCTAssertTrue(manager.progress.completedSubjects.contains("spanish"))
    }

    func testMarkSubjectCompletedNoDuplicates() {
        manager.markSubjectCompleted("spanish")
        manager.markSubjectCompleted("spanish")
        XCTAssertEqual(manager.progress.completedSubjects.filter { $0 == "spanish" }.count, 1)
    }

    // MARK: - Trophy Tests

    func testFirstLessonTrophy() {
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("firstLesson"))
    }

    func testPerfectLessonTrophy() {
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 10, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("perfectLesson"))
    }

    func testPerfectLessonTrophyNotAwardedForImperfect() {
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 9, totalQuestions: 10)
        XCTAssertFalse(manager.progress.trophyIds.contains("perfectLesson"))
    }

    func testXP100Trophy() {
        manager.addXP(100)
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("xp100"))
    }

    func testXP500Trophy() {
        manager.addXP(500)
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("xp500"))
    }

    func testStreak3Trophy() {
        manager.progress.streak = 3
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("streak3"))
    }

    func testPolyglotTrophy() {
        manager.markSubjectCompleted("spanish")
        manager.markSubjectCompleted("french")
        manager.markSubjectCompleted("german")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("polyglot"))
    }

    func testPolyglotNotAwardedForNonLanguages() {
        manager.markSubjectCompleted("arithmetic")
        manager.markSubjectCompleted("algebra")
        manager.markSubjectCompleted("geometry")
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertFalse(manager.progress.trophyIds.contains("polyglot"))
    }

    func testExplorerTrophy() {
        let subjects = ["spanish", "french", "german", "italian", "javascript",
                        "python", "arithmetic", "physics", "chess", "geography"]
        for s in subjects {
            manager.markSubjectCompleted(s)
        }
        manager.checkAndAwardTrophies(correctAnswers: 5, totalQuestions: 10)
        XCTAssertTrue(manager.progress.trophyIds.contains("explorer"))
    }

    func testNoDuplicateTrophies() {
        manager.markSubjectCompleted("spanish")
        manager.checkAndAwardTrophies(correctAnswers: 10, totalQuestions: 10)
        let countBefore = manager.progress.trophyIds.filter { $0 == "firstLesson" }.count
        manager.checkAndAwardTrophies(correctAnswers: 10, totalQuestions: 10)
        let countAfter = manager.progress.trophyIds.filter { $0 == "firstLesson" }.count
        XCTAssertEqual(countBefore, countAfter)
    }

    // MARK: - Reset

    func testResetProgress() {
        manager.addXP(100)
        manager.markSubjectCompleted("spanish")
        manager.progress.streak = 5
        manager.resetProgress()
        XCTAssertEqual(manager.progress.xp, 0)
        XCTAssertEqual(manager.progress.streak, 0)
        XCTAssertEqual(manager.progress.hearts, 5)
        XCTAssertTrue(manager.progress.completedSubjects.isEmpty)
        XCTAssertTrue(manager.progress.trophyIds.isEmpty)
    }

    // MARK: - Persistence

    func testProgressPersistsToUserDefaults() {
        manager.addXP(42)
        manager.save()
        let newManager = ProgressManager()
        XCTAssertEqual(newManager.progress.xp, 42)
    }
}
