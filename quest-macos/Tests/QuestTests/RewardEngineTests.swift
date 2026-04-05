import Testing
@testable import Quest

@Suite("RewardEngine")
struct RewardEngineTests {
    @Test func emptyRewardsReturnsNotGranted() {
        let result = RewardEngine.rollReward([])
        #expect(result.granted == false)
        #expect(result.reward == nil)
    }

    @Test func rewardRollReturnsValidReward() {
        let reward = Reward(text: "Coffee break")
        let result = RewardEngine.rollReward([reward])
        // With 80% chance, most runs will grant. Just verify structure.
        if result.granted {
            #expect(result.reward != nil)
        }
    }
}
