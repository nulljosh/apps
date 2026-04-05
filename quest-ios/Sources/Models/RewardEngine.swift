import Foundation

enum RewardEngine {
    static func rollReward(_ rewards: [Reward]) -> (granted: Bool, reward: Reward?) {
        let active = rewards.filter(\.active)
        guard !active.isEmpty else { return (false, nil) }
        if Double.random(in: 0...1) > 0.8 { return (false, nil) }
        return (true, active.randomElement())
    }
}
