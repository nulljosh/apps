import SwiftUI
import CoreLocation

// MARK: - Baddie

struct Baddie: Identifiable {
    let id: Int
    let name: String
    let vibes: [String]
    let clout: Int
    let streak: Int
    let maxStreak: Int
    let verified: Bool
    let color: Color
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Follower

struct Follower: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let watching: Bool
}

// MARK: - Activity Item

struct ActivityItem: Identifiable {
    let id = UUID()
    let icon: String
    let bgColor: Color
    let text: String
    let time: String
}

// MARK: - Share Mode

enum ShareMode: String, CaseIterable {
    case exact = "Exact"
    case fuzzy = "Fuzzy"
    case district = "District"

    var description: String {
        switch self {
        case .exact: return "Precise pin"
        case .fuzzy: return "~500m radius"
        case .district: return "Area only"
        }
    }

    var icon: String {
        switch self {
        case .exact: return "mappin.circle.fill"
        case .fuzzy: return "circle.dashed"
        case .district: return "map.fill"
        }
    }
}

// MARK: - Leader

struct Leader: Identifiable {
    let id = UUID()
    let name: String
    let clout: Int
    let color: Color
    let verified: Bool
    let rank: Int
}

// MARK: - Sample Data

enum SampleData {

    static let vibes = ["all", "gym", "alt", "artsy", "downtown", "night-owl"]

    static let baddies: [Baddie] = [
        Baddie(id: 1, name: "luna.x", vibes: ["alt", "artsy"], clout: 9420, streak: 7, maxStreak: 7, verified: true, color: Color(hex: "#8b5cf6"), coordinate: CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)),
        Baddie(id: 2, name: "kaylafit", vibes: ["gym", "downtown"], clout: 7100, streak: 3, maxStreak: 7, verified: false, color: Color(hex: "#ff2d78"), coordinate: CLLocationCoordinate2D(latitude: 49.2785, longitude: -123.1187)),
        Baddie(id: 3, name: "nyx.dream", vibes: ["alt", "night-owl"], clout: 12300, streak: 14, maxStreak: 14, verified: true, color: Color(hex: "#06b6d4"), coordinate: CLLocationCoordinate2D(latitude: 49.2845, longitude: -123.1130)),
        Baddie(id: 4, name: "jess.vibes", vibes: ["artsy", "downtown"], clout: 5200, streak: 2, maxStreak: 7, verified: false, color: Color(hex: "#f59e0b"), coordinate: CLLocationCoordinate2D(latitude: 49.2760, longitude: -123.1260)),
        Baddie(id: 5, name: "mira.wav", vibes: ["alt", "artsy", "night-owl"], clout: 15800, streak: 21, maxStreak: 30, verified: true, color: Color(hex: "#8b5cf6"), coordinate: CLLocationCoordinate2D(latitude: 49.2870, longitude: -123.1150)),
        Baddie(id: 6, name: "zoefit", vibes: ["gym"], clout: 3400, streak: 1, maxStreak: 7, verified: false, color: Color(hex: "#10b981"), coordinate: CLLocationCoordinate2D(latitude: 49.2800, longitude: -123.1290)),
        Baddie(id: 7, name: "aria.noir", vibes: ["alt", "night-owl"], clout: 8900, streak: 5, maxStreak: 7, verified: false, color: Color(hex: "#ff2d78"), coordinate: CLLocationCoordinate2D(latitude: 49.2815, longitude: -123.1100)),
        Baddie(id: 8, name: "sage.xo", vibes: ["artsy", "downtown"], clout: 6700, streak: 4, maxStreak: 7, verified: true, color: Color(hex: "#06b6d4"), coordinate: CLLocationCoordinate2D(latitude: 49.2750, longitude: -123.1175)),
        Baddie(id: 9, name: "val.jpeg", vibes: ["artsy", "alt"], clout: 4300, streak: 9, maxStreak: 14, verified: false, color: Color(hex: "#f59e0b"), coordinate: CLLocationCoordinate2D(latitude: 49.2860, longitude: -123.1240)),
        Baddie(id: 10, name: "kira.glow", vibes: ["gym", "downtown"], clout: 11200, streak: 6, maxStreak: 7, verified: true, color: Color(hex: "#8b5cf6"), coordinate: CLLocationCoordinate2D(latitude: 49.2790, longitude: -123.1080)),
    ]

    static let followers: [Follower] = [
        Follower(name: "dev.mode", color: Color(hex: "#8b5cf6"), watching: true),
        Follower(name: "samantha.k", color: Color(hex: "#ff2d78"), watching: true),
        Follower(name: "riley.raw", color: Color(hex: "#06b6d4"), watching: false),
        Follower(name: "jax.wav", color: Color(hex: "#f59e0b"), watching: true),
        Follower(name: "emma.xyz", color: Color(hex: "#10b981"), watching: false),
        Follower(name: "noah.png", color: Color(hex: "#8b5cf6"), watching: true),
    ]

    static let activityFeed: [ActivityItem] = [
        ActivityItem(icon: "mappin", bgColor: Theme.accent.opacity(0.12), text: "luna.x unlocked your location", time: "2m ago"),
        ActivityItem(icon: "flame.fill", bgColor: Theme.violet.opacity(0.12), text: "Streak bonus +50 tokens", time: "8m ago"),
        ActivityItem(icon: "person.fill", bgColor: Theme.cyan.opacity(0.12), text: "New follower: kira.glow", time: "15m ago"),
        ActivityItem(icon: "dollarsign.circle.fill", bgColor: Theme.green.opacity(0.12), text: "mira.wav tipped 200 tokens", time: "22m ago"),
        ActivityItem(icon: "mappin", bgColor: Theme.accent.opacity(0.12), text: "sage.xo unlocked your location", time: "35m ago"),
        ActivityItem(icon: "bolt.fill", bgColor: Theme.violet.opacity(0.12), text: "Baddie Hours bonus +100 tokens", time: "1h ago"),
        ActivityItem(icon: "person.fill", bgColor: Theme.cyan.opacity(0.12), text: "New follower: val.jpeg", time: "1h ago"),
        ActivityItem(icon: "trophy.fill", bgColor: Theme.amber.opacity(0.12), text: "You reached Top 50 in Vancouver", time: "2h ago"),
    ]

    static let leaders: [Leader] = [
        Leader(name: "mira.wav", clout: 15800, color: Color(hex: "#8b5cf6"), verified: true, rank: 1),
        Leader(name: "nyx.dream", clout: 12300, color: Color(hex: "#06b6d4"), verified: true, rank: 2),
        Leader(name: "kira.glow", clout: 11200, color: Color(hex: "#8b5cf6"), verified: true, rank: 3),
    ]

    static let hours = ["6am", "8am", "10am", "12pm", "2pm", "4pm", "6pm", "8pm", "10pm", "12am", "2am", "4am"]
    static let activeHourIndices: Set<Int> = [6, 7, 8, 9]
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
