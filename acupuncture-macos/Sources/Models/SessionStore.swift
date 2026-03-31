import Foundation
import Observation

struct Session: Identifiable, Codable {
    let id: UUID
    let type: String
    let name: String
    let area: String
    let date: Date
    var notes: String

    init(type: String, name: String, area: String, notes: String = "") {
        self.id = UUID()
        self.type = type
        self.name = name
        self.area = area
        self.date = Date()
        self.notes = notes
    }
}

@Observable
final class SessionStore {
    var sessions: [Session] = []

    private let key = "acu_sessions"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            sessions = decoded
        }
    }

    func add(_ session: Session) {
        sessions.insert(session, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        save()
    }

    func delete(id: UUID) {
        sessions.removeAll { $0.id == id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
