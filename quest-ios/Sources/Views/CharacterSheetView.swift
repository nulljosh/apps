import SwiftUI
import SwiftData

struct CharacterSheetView: View {
    @Bindable var profile: CharacterProfile
    @Query(filter: #Predicate<Quest> { $0.completed }) private var completedQuests: [Quest]
    @Query(filter: #Predicate<Quest> { !$0.completed }) private var activeQuests: [Quest]

    private var dominantClass: String {
        let counts = Dictionary(grouping: completedQuests, by: \.category)
            .mapValues(\.count)
        guard let top = counts.max(by: { $0.value < $1.value }) else { return "Adventurer" }
        return top.key.className
    }

    private var initials: String {
        profile.name.split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    WaxSealView(text: initials.isEmpty ? "?" : initials, size: 80)

                    TextField("Name", text: $profile.name)
                        .font(QuestTheme.headingFont)
                        .foregroundStyle(QuestTheme.parchment)
                        .multilineTextAlignment(.center)

                    Text(dominantClass)
                        .font(QuestTheme.labelFont)
                        .tracking(2)
                        .textCase(.uppercase)
                        .foregroundStyle(QuestTheme.gold)

                    HStack(spacing: 8) {
                        Text("Lvl \(profile.level)")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundStyle(QuestTheme.goldLight)
                        Text(profile.title)
                            .font(QuestTheme.bodyFont)
                            .italic()
                            .foregroundStyle(QuestTheme.parchmentDark)
                    }

                    XPBarView(totalXP: profile.totalXP)
                        .padding(.horizontal, 32)

                    Divider().overlay(QuestTheme.goldDark)

                    HStack(spacing: 32) {
                        StatBlock(value: "\(completedQuests.count)", label: "Completed")
                        StatBlock(value: "\(activeQuests.count)", label: "Active")
                        VStack(spacing: 4) {
                            CandleView(streak: profile.currentStreak)
                            Text("Streak")
                                .font(QuestTheme.labelFont)
                                .tracking(1)
                                .textCase(.uppercase)
                                .foregroundStyle(QuestTheme.parchmentDark)
                        }
                    }

                    Divider().overlay(QuestTheme.goldDark)

                    GoldCoinView(amount: profile.totalXP)
                }
                .padding(.vertical, 32)
            }
            .background(QuestTheme.leatherDark)
            .navigationTitle("Character")
        }
    }
}

struct StatBlock: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(QuestTheme.parchment)
            Text(label)
                .font(QuestTheme.labelFont)
                .tracking(1)
                .textCase(.uppercase)
                .foregroundStyle(QuestTheme.parchmentDark)
        }
    }
}

struct CandleView: View {
    let streak: Int

    var body: some View {
        VStack(spacing: 0) {
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [.yellow, .orange, .red, .clear],
                        center: .init(x: 0.5, y: 0.6),
                        startRadius: 0,
                        endRadius: 12
                    )
                )
                .frame(width: 12, height: CGFloat(min(16 + streak * 3, 40)))

            RoundedRectangle(cornerRadius: 2)
                .fill(QuestTheme.parchmentDark)
                .frame(width: 14, height: 28)

            Text("\(streak)")
                .font(QuestTheme.labelFont)
                .foregroundStyle(QuestTheme.gold)
                .padding(.top, 4)
        }
    }
}
