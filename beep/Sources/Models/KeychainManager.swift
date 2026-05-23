import Foundation
import Security

enum KeychainManager {
    private static let service = "com.nulljosh.beep.credentials"
    private static let emailAccount = "email"
    private static let passwordAccount = "password"

    static var hasCredentials: Bool {
        (try? loadCredentials()) != nil
    }

    static func saveCredentials(email: String, password: String) throws {
        deleteCredentials()
        try save(value: email, account: emailAccount)
        try save(value: password, account: passwordAccount)
    }

    static func loadCredentials() throws -> (email: String, password: String) {
        let email = try load(account: emailAccount)
        let password = try load(account: passwordAccount)
        return (email, password)
    }

    static func deleteCredentials() {
        delete(account: emailAccount)
        delete(account: passwordAccount)
    }

    // MARK: - Private

    private static func save(value: String, account: String) throws {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.saveFailed(status) }
    }

    private static func load(account: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.notFound
        }
        return value
    }

    private static func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }

    enum KeychainError: Error {
        case notFound
        case saveFailed(OSStatus)
    }
}
