import Testing
@testable import Quest

@Suite("XPEngine")
struct XPEngineTests {
    @Test func levelAt0XP() {
        #expect(XPEngine.getLevel(0) == 0)
    }

    @Test func levelAt50XP() {
        #expect(XPEngine.getLevel(50) == 1)
    }

    @Test func levelAt200XP() {
        #expect(XPEngine.getLevel(200) == 2)
    }

    @Test func levelAt5000XP() {
        #expect(XPEngine.getLevel(5000) == 10)
    }

    @Test func titleForLevel0() {
        #expect(XPEngine.getTitle(0) == "Squire")
    }

    @Test func titleForLevel1() {
        #expect(XPEngine.getTitle(1) == "Knight")
    }

    @Test func titleForHighLevel() {
        #expect(XPEngine.getTitle(100) == "Mythic")
    }

    @Test func xpProgress() {
        let p = XPEngine.xpProgress(75)
        #expect(p.level == 1)
        #expect(p.progress == 25)
        #expect(p.needed == 150)
    }

    @Test func allRankXPValues() {
        #expect(DifficultyRank.F.xpReward == 10)
        #expect(DifficultyRank.D.xpReward == 25)
        #expect(DifficultyRank.C.xpReward == 50)
        #expect(DifficultyRank.B.xpReward == 100)
        #expect(DifficultyRank.A.xpReward == 200)
        #expect(DifficultyRank.S.xpReward == 500)
    }
}
