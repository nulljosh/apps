import CloudKit
import Foundation

@MainActor
final class SyncManager {
    static let shared = SyncManager()

    private let container = CKContainer(identifier: "iCloud.com.nulljosh.browser")
    private let privateDB: CKDatabase
    private(set) var isSyncing = false
    private(set) var lastSyncDate: Date?
    private var subscriptionSaved = false

    private init() {
        privateDB = container.privateCloudDatabase
    }

    func checkAccountStatus() async -> Bool {
        do {
            let status = try await container.accountStatus()
            return status == .available
        } catch {
            return false
        }
    }

    func syncBookmarks(_ bookmarks: [Bookmark]) async {
        isSyncing = true
        defer { isSyncing = false }

        for bookmark in bookmarks {
            let recordID = CKRecord.ID(recordName: "bookmark-\(bookmark.id.uuidString)")
            let record = CKRecord(recordType: "Bookmark", recordID: recordID)
            record["url"] = bookmark.url.absoluteString as CKRecordValue
            record["title"] = bookmark.title as CKRecordValue
            record["folder"] = bookmark.folder as CKRecordValue
            record["dateAdded"] = bookmark.dateAdded as CKRecordValue

            do {
                try await privateDB.save(record)
            } catch {
                continue
            }
        }

        lastSyncDate = Date()
    }

    func fetchBookmarks() async -> [Bookmark] {
        let query = CKQuery(recordType: "Bookmark", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]

        do {
            let (results, _) = try await privateDB.records(matching: query)
            return results.compactMap { _, result in
                guard let record = try? result.get(),
                      let urlString = record["url"] as? String,
                      let url = URL(string: urlString),
                      let title = record["title"] as? String else { return nil }

                let folder = record["folder"] as? String ?? "Bookmarks"
                let dateAdded = record["dateAdded"] as? Date ?? Date()
                let idString = record.recordID.recordName.replacingOccurrences(of: "bookmark-", with: "")
                let id = UUID(uuidString: idString) ?? UUID()

                return Bookmark(id: id, url: url, title: title, dateAdded: dateAdded, folder: folder)
            }
        } catch {
            return []
        }
    }

    func syncOpenTabs(_ tabs: [Tab]) async {
        isSyncing = true
        defer { isSyncing = false }

        for tab in tabs where !tab.isPrivate {
            let recordID = CKRecord.ID(recordName: "tab-\(tab.id.uuidString)")
            let record = CKRecord(recordType: "OpenTab", recordID: recordID)
            record["url"] = tab.url.absoluteString as CKRecordValue
            record["title"] = tab.title as CKRecordValue
            record["isPinned"] = (tab.isPinned ? 1 : 0) as CKRecordValue

            do {
                try await privateDB.save(record)
            } catch {
                continue
            }
        }

        lastSyncDate = Date()
    }

    func setupSubscription() async {
        guard !subscriptionSaved else { return }

        let subscription = CKDatabaseSubscription(subscriptionID: "browser-changes")
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        do {
            try await privateDB.save(subscription)
            subscriptionSaved = true
        } catch {
            // subscription may already exist
        }
    }
}
