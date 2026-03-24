import Foundation

@MainActor
final class TimeSystem {
    private var accumulated: TimeInterval = 0
    private let tickInterval: TimeInterval = 1.0
    let ticksPerDay = 240

    func update(deltaTime: TimeInterval, gameState: GameState) -> Bool {
        guard !gameState.isPaused else { return false }
        accumulated += deltaTime
        if accumulated >= tickInterval {
            accumulated -= tickInterval
            gameState.currentTick += 1
            gameState.currentHour = (gameState.currentTick % ticksPerDay) / 10
            gameState.isNight = gameState.currentHour >= 20 || gameState.currentHour < 6
            return true
        }
        return false
    }
}
