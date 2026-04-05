import SwiftUI
import SwiftData

@main
struct QuestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Quest.self, CharacterProfile.self, Reward.self])
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [CharacterProfile]
    @State private var selectedTab = 0

    private var profile: CharacterProfile {
        if let existing = profiles.first { return existing }
        let newProfile = CharacterProfile()
        context.insert(newProfile)
        return newProfile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            QuestBoardView(profile: profile)
                .tabItem { Label("Quests", systemImage: "scroll") }
                .tag(0)
            CharacterSheetView(profile: profile)
                .tabItem { Label("Character", systemImage: "person.crop.circle") }
                .tag(1)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(2)
        }
        .tint(QuestTheme.gold)
        .onAppear { profile.updateStreak() }
    }
}
