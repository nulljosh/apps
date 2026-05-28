import UserNotifications
import Foundation

enum NotificationService {
    static func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }

    static func scheduleAlerts(parts: [Part]) async {
        let lowCount = parts.filter { $0.isLowStock }.count
        let firstName = parts.first(where: { $0.isLowStock })?.name ?? ""
        await scheduleAlertsIfNeeded(lowCount: lowCount, firstName: firstName)
    }

    static func scheduleAlertsIfNeeded(lowCount: Int, firstName: String) async {
        let center = UNUserNotificationCenter.current()
        await center.removeAllPendingNotificationRequests()
        guard lowCount > 0 else { return }
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }
        let content = UNMutableNotificationContent()
        content.title = "Low Stock"
        content.body = lowCount == 1 ? "\(firstName) needs restocking" : "\(lowCount) parts need restocking"
        content.sound = .default
        var c = DateComponents(); c.hour = 9; c.minute = 0
        try? await center.add(UNNotificationRequest(
            identifier: "bcgd-lowstock",
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: c, repeats: true)
        ))
    }
}
