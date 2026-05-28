import Foundation

struct Backup: Codable {
    var parts: [PartData]
    var jobs: [JobData]
    var exportedAt: String
}

enum BackupService {
    static func export(parts: [Part], jobs: [Job]) -> Data {
        let b = Backup(parts: parts.map { $0.data }, jobs: jobs.map { $0.data },
                       exportedAt: ISO8601DateFormatter().string(from: Date()))
        return (try? JSONEncoder().encode(b)) ?? Data()
    }

    static func writeTemp(_ data: Data) -> URL? {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("bcgd-backup-\(Int(Date().timeIntervalSince1970)).json")
        try? data.write(to: url)
        return url
    }

    static func load(from url: URL) -> Backup? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(Backup.self, from: data)
    }
}
