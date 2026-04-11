import Testing
@testable import ClaudeUsage

@MainActor
struct UsageStoreTests {
    @Test func addEntry() async throws {
        let store = UsageStore()
        let before = store.entries.count
        let entry = UsageEntry(provider: .claude, conversations: 5, tokensEstimate: 10000, costEstimate: 0)
        store.add(entry)
        #expect(store.entries.count == before + 1)
    }

    @Test func deleteEntry() async throws {
        let store = UsageStore()
        let entry = UsageEntry(provider: .chatgpt, conversations: 3)
        store.add(entry)
        let countAfterAdd = store.entries.count
        store.delete(entry)
        #expect(store.entries.count == countAfterAdd - 1)
    }

    @Test func updateEntry() async throws {
        let store = UsageStore()
        var entry = UsageEntry(provider: .claude, conversations: 1)
        store.add(entry)
        entry.conversations = 10
        store.update(entry)
        let found = store.entries.first { $0.id == entry.id }
        #expect(found?.conversations == 10)
    }

    @Test func currentMonthStats() async throws {
        let store = UsageStore()
        store.entries = []
        let e1 = UsageEntry(provider: .claude, date: Date(), conversations: 4, tokensEstimate: 5000, costEstimate: 1.50)
        let e2 = UsageEntry(provider: .claude, date: Date(), conversations: 6, tokensEstimate: 8000, costEstimate: 2.25)
        store.add(e1)
        store.add(e2)
        #expect(store.currentMonthConversations == 10)
        #expect(store.currentMonthTokens == 13000)
        #expect(abs(store.currentMonthCost - 3.75) < 0.001)
    }

    @Test func exportImportRoundtrip() async throws {
        let store = UsageStore()
        store.entries = []
        let entry = UsageEntry(provider: .gemini, conversations: 2, model: "gemini-pro")
        store.add(entry)
        let json = store.exportJSON()
        #expect(!json.isEmpty)

        let store2 = UsageStore()
        store2.entries = []
        try store2.importJSON(json)
        #expect(store2.entries.count == 1)
        #expect(store2.entries.first?.provider == .gemini)
        #expect(store2.entries.first?.model == "gemini-pro")
    }

    @Test func providerFilter() async throws {
        let store = UsageStore()
        store.entries = []
        store.add(UsageEntry(provider: .claude, conversations: 3))
        store.add(UsageEntry(provider: .chatgpt, conversations: 2))
        store.selectedProvider = .claude
        #expect(store.filteredEntries.count == 1)
        #expect(store.filteredEntries.first?.provider == .claude)
        store.selectedProvider = nil
        #expect(store.filteredEntries.count == 2)
    }

    @Test func last30DaysActivity() async throws {
        let store = UsageStore()
        store.entries = []
        store.add(UsageEntry(provider: .claude, date: Date(), conversations: 5))
        let activity = store.last30DaysActivity()
        #expect(activity.count == 30)
        let today = activity.last
        #expect(today?.conversations == 5)
    }
}
