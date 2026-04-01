import Foundation

struct Trophy: Identifiable {
    let id: String
    let name: String
    let desc: String
    let icon: String
}

enum Trophies {
    static let all: [Trophy] = [
        Trophy(id: "firstLesson", name: "First Steps", desc: "Complete your first lesson", icon: "figure.walk"),
        Trophy(id: "perfectLesson", name: "Perfectionist", desc: "Score 10/10 on a lesson", icon: "crown.fill"),
        Trophy(id: "streak3", name: "On Fire", desc: "Reach a 3-day streak", icon: "flame.fill"),
        Trophy(id: "streak7", name: "Dedicated", desc: "Reach a 7-day streak", icon: "calendar.badge.checkmark"),
        Trophy(id: "streak30", name: "Unstoppable", desc: "Reach a 30-day streak", icon: "bolt.fill"),
        Trophy(id: "xp100", name: "Learner", desc: "Earn 100 XP", icon: "star.fill"),
        Trophy(id: "xp500", name: "Scholar", desc: "Earn 500 XP", icon: "graduationcap.fill"),
        Trophy(id: "xp1000", name: "Master", desc: "Earn 1000 XP", icon: "wand.and.stars"),
        Trophy(id: "polyglot", name: "Polyglot", desc: "Study 3 language tracks", icon: "globe"),
        Trophy(id: "mathWiz", name: "Math Wizard", desc: "Complete every math topic", icon: "function"),
        Trophy(id: "explorer", name: "Explorer", desc: "Try 10 different subjects", icon: "safari")
    ]

    static func trophy(for id: String) -> Trophy? {
        all.first { $0.id == id }
    }
}
