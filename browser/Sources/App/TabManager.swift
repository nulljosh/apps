import Foundation
import WebKit

@MainActor
final class TabManager {
    static let shared = TabManager()

    private var lastAccessDates: [UUID: Date] = [:]
    private var suspendedScrollPositions: [UUID: CGFloat] = [:]
    private var suspensionTimer: Timer?
    private var crashRecoveryTimer: Timer?

    private init() {}

    func markAccessed(tabID: UUID) {
        lastAccessDates[tabID] = Date()
    }

    func lastAccess(for tabID: UUID) -> Date? {
        lastAccessDates[tabID]
    }

    func saveScrollPosition(_ position: CGFloat, for tabID: UUID) {
        suspendedScrollPositions[tabID] = position
    }

    func scrollPosition(for tabID: UUID) -> CGFloat {
        suspendedScrollPositions[tabID] ?? 0
    }

    func clearScrollPosition(for tabID: UUID) {
        suspendedScrollPositions.removeValue(forKey: tabID)
    }

    func removeTab(tabID: UUID) {
        lastAccessDates.removeValue(forKey: tabID)
        suspendedScrollPositions.removeValue(forKey: tabID)
    }

    func startSuspensionTimer(suspensionMinutes: Int, checkHandler: @escaping (UUID, Date) -> Void) {
        suspensionTimer?.invalidate()
        let interval = TimeInterval(max(suspensionMinutes * 60 / 2, 30))
        suspensionTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                for (tabID, lastAccess) in self.lastAccessDates {
                    checkHandler(tabID, lastAccess)
                }
            }
        }
    }

    func stopSuspensionTimer() {
        suspensionTimer?.invalidate()
        suspensionTimer = nil
    }

    func startCrashRecoveryTimer(saveHandler: @escaping () -> Void) {
        crashRecoveryTimer?.invalidate()
        crashRecoveryTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { @MainActor in
                saveHandler()
            }
        }
    }

    func stopCrashRecoveryTimer() {
        crashRecoveryTimer?.invalidate()
        crashRecoveryTimer = nil
    }
}
