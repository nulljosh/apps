import Foundation

struct UserRecord: Codable {
    var name: String
    var pw: String
}

struct SessionUser: Codable {
    var username: String
    var name: String
}

enum AuthError: LocalizedError {
    case invalidCredentials, usernameTaken, tooShort, nameRequired
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid username or password."
        case .usernameTaken: return "Username already taken."
        case .tooShort: return "Password must be at least 6 characters."
        case .nameRequired: return "Display name required."
        }
    }
}

class AuthManager: ObservableObject {
    @Published var currentUser: SessionUser?

    private func djb2Hash(_ s: String) -> String {
        var h: UInt32 = 5381
        for c in s.unicodeScalars { h = (h &* 33) ^ UInt32(c.value) }
        return String(h, radix: 36)
    }

    private func getUsers() -> [String: UserRecord] {
        guard let data = UserDefaults.standard.data(forKey: "ch-users"),
              let users = try? JSONDecoder().decode([String: UserRecord].self, from: data)
        else { return [:] }
        return users
    }

    private func saveUsers(_ users: [String: UserRecord]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: "ch-users")
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "ch-session"),
           let session = try? JSONDecoder().decode(SessionUser.self, from: data) {
            currentUser = session
        }
        var users = getUsers()
        if users["joshua"] == nil {
            users["joshua"] = UserRecord(name: "Joshua Trommel", pw: djb2Hash("charters"))
            saveUsers(users)
        }
    }

    func login(username: String, password: String) throws {
        let users = getUsers()
        guard let record = users[username.lowercased()],
              record.pw == djb2Hash(password) else { throw AuthError.invalidCredentials }
        let session = SessionUser(username: username.lowercased(), name: record.name)
        currentUser = session
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "ch-session")
        }
    }

    func register(username: String, name: String, password: String) throws {
        guard !name.isEmpty else { throw AuthError.nameRequired }
        guard password.count >= 6 else { throw AuthError.tooShort }
        var users = getUsers()
        let u = username.lowercased()
        guard users[u] == nil else { throw AuthError.usernameTaken }
        users[u] = UserRecord(name: name, pw: djb2Hash(password))
        saveUsers(users)
        let session = SessionUser(username: u, name: name)
        currentUser = session
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "ch-session")
        }
    }

    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "ch-session")
    }
}
