import Testing
@testable import ClaudeUsageIOS

@MainActor
struct UsageStoreTests {
    @Test func addEntry() async throws {
        let store = UsageStore()
        let before = store.entries.count
        store.add(UsageEntry(provider: .claude, conversations: 5, tokensEstimate: 10000, costEstimate: 1.5))
        #expect(store.entries.count == before + 1)
    }

    @Test func deleteEntry() async throws {
        let store = UsageStore()
        let entry = UsageEntry(provider: .chatgpt, conversations: 3)
        store.add(entry)
        let after = store.entries.count
        store.delete(entry)
        #expect(store.entries.count == after - 1)
    }

    @Test func updateEntry() async throws {
        let store = UsageStore()
        var entry = UsageEntry(provider: .claude, conversations: 1)
        store.add(entry)
        entry.conversations = 10
        store.update(entry)
        #expect(store.entries.first { $0.id == entry.id }?.conversations == 10)
    }

    @Test func currentMonthStats() async throws {
        let store = UsageStore()
        store.entries = []
        store.add(UsageEntry(provider: .claude, date: Date(), conversations: 3, tokensEstimate: 5000, costEstimate: 1.0))
        store.add(UsageEntry(provider: .chatgpt, date: Date(), conversations: 7, tokensEstimate: 8000, costEstimate: 2.0))
        #expect(store.currentMonthConversations == 10)
        #expect(abs(store.currentMonthCost - 3.0) < 0.001)
    }

    @Test func providerFilter() async throws {
        let store = UsageStore()
        store.entries = []
        store.add(UsageEntry(provider: .claude, conversations: 2))
        store.add(UsageEntry(provider: .gemini, conversations: 1))
        store.selectedProvider = .claude
        #expect(store.filteredEntries.allSatisfy { $0.provider == .claude })
        store.selectedProvider = nil
        #expect(store.filteredEntries.count == 2)
    }

    @Test func exportImportRoundtrip() async throws {
        let store = UsageStore()
        store.entries = []
        store.add(UsageEntry(provider: .gemini, conversations: 4, model: "gemini-2.0"))
        let json = store.exportJSON()
        #expect(!json.isEmpty)
        let store2 = UsageStore()
        store2.entries = []
        try store2.importJSON(json)
        #expect(store2.entries.count == 1)
        #expect(store2.entries.first?.model == "gemini-2.0")
    }
}
