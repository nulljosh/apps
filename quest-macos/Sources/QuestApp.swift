import SwiftUI
import SwiftData

@main
struct QuestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Quest.self, CharacterProfile.self, Reward.self])
                .frame(minWidth: 800, minHeight: 600)
        }
        .defaultSize(width: 1000, height: 700)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [CharacterProfile]
    @State private var selectedView: SidebarItem = .quests

    private var profile: CharacterProfile {
        if let existing = profiles.first { return existing }
        let newProfile = CharacterProfile()
        context.insert(newProfile)
        return newProfile
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedView)
        } detail: {
            switch selectedView {
            case .quests:
                QuestBoardView(profile: profile)
            case .character:
                CharacterSheetView(profile: profile)
            case .settings:
                SettingsView()
            }
        }
        .onAppear { profile.updateStreak() }
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case quests = "Quest Board"
    case character = "Character"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .quests: "scroll"
        case .character: "person.crop.circle"
        case .settings: "gearshape"
        }
    }
}
