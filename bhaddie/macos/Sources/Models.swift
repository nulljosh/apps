import Foundation
import CoreLocation

struct Baddie: Identifiable {
    let id: Int
    let name: String
    let vibes: [String]
    let clout: Int
    let streak: Int
    let maxStreak: Int
    let verified: Bool
    let color: String
    let coordinate: CLLocationCoordinate2D
}

struct Follower: Identifiable {
    let id: Int
    let name: String
    let clout: Int
    let verified: Bool
}

struct ActivityItem: Identifiable {
    let id: Int
    let icon: String
    let label: String
    let amount: String
    let timestamp: String
    let positive: Bool
}

enum ShareMode: String, CaseIterable, Identifiable {
    case exact = "Exact"
    case fuzzy = "Fuzzy"
    case district = "District"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .exact: return "location.fill"
        case .fuzzy: return "location.circle"
        case .district: return "map"
        }
    }

    var description: String {
        switch self {
        case .exact: return "Precise pin"
        case .fuzzy: return "~500m radius"
        case .district: return "Neighbourhood only"
        }
    }
}

struct Leader: Identifiable {
    let id: Int
    let rank: Int
    let name: String
    let clout: Int
    let verified: Bool
}

// MARK: - Sample Data

let sampleBaddies: [Baddie] = [
    Baddie(id: 1, name: "luna.x", vibes: ["alt", "artsy"], clout: 9420, streak: 7, maxStreak: 7, verified: true, color: "#8b5cf6", coordinate: CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)),
    Baddie(id: 2, name: "kaylafit", vibes: ["gym", "downtown"], clout: 7100, streak: 3, maxStreak: 7, verified: false, color: "#ff2d78", coordinate: CLLocationCoordinate2D(latitude: 49.2785, longitude: -123.1187)),
    Baddie(id: 3, name: "nyx.dream", vibes: ["alt", "night-owl"], clout: 12300, streak: 14, maxStreak: 14, verified: true, color: "#06b6d4", coordinate: CLLocationCoordinate2D(latitude: 49.2845, longitude: -123.1130)),
    Baddie(id: 4, name: "jess.vibes", vibes: ["artsy", "downtown"], clout: 5200, streak: 2, maxStreak: 7, verified: false, color: "#f59e0b", coordinate: CLLocationCoordinate2D(latitude: 49.2760, longitude: -123.1260)),
    Baddie(id: 5, name: "mira.wav", vibes: ["alt", "artsy", "night-owl"], clout: 15800, streak: 21, maxStreak: 30, verified: true, color: "#8b5cf6", coordinate: CLLocationCoordinate2D(latitude: 49.2870, longitude: -123.1150)),
    Baddie(id: 6, name: "zoefit", vibes: ["gym"], clout: 3400, streak: 1, maxStreak: 7, verified: false, color: "#10b981", coordinate: CLLocationCoordinate2D(latitude: 49.2800, longitude: -123.1290)),
    Baddie(id: 7, name: "aria.noir", vibes: ["alt", "night-owl"], clout: 8900, streak: 5, maxStreak: 7, verified: false, color: "#ff2d78", coordinate: CLLocationCoordinate2D(latitude: 49.2815, longitude: -123.1100)),
    Baddie(id: 8, name: "sage.xo", vibes: ["artsy", "downtown"], clout: 6700, streak: 4, maxStreak: 7, verified: true, color: "#06b6d4", coordinate: CLLocationCoordinate2D(latitude: 49.2750, longitude: -123.1175)),
    Baddie(id: 9, name: "val.jpeg", vibes: ["artsy", "alt"], clout: 4300, streak: 9, maxStreak: 14, verified: false, color: "#f59e0b", coordinate: CLLocationCoordinate2D(latitude: 49.2860, longitude: -123.1240)),
    Baddie(id: 10, name: "kira.glow", vibes: ["gym", "downtown"], clout: 11200, streak: 6, maxStreak: 7, verified: true, color: "#8b5cf6", coordinate: CLLocationCoordinate2D(latitude: 49.2790, longitude: -123.1080)),
]

let sampleFollowers: [Follower] = [
    Follower(id: 1, name: "luna.x", clout: 9420, verified: true),
    Follower(id: 2, name: "kaylafit", clout: 7100, verified: false),
    Follower(id: 3, name: "nyx.dream", clout: 12300, verified: true),
    Follower(id: 4, name: "jess.vibes", clout: 5200, verified: false),
    Follower(id: 5, name: "sage.xo", clout: 6700, verified: true),
    Follower(id: 6, name: "val.jpeg", clout: 4300, verified: false),
]

let sampleActivities: [ActivityItem] = [
    ActivityItem(id: 1, icon: "arrow.down.circle.fill", label: "Beacon tip from luna.x", amount: "+24", timestamp: "2m ago", positive: true),
    ActivityItem(id: 2, icon: "arrow.up.circle.fill", label: "Sent gift to nyx.dream", amount: "-10", timestamp: "15m ago", positive: false),
    ActivityItem(id: 3, icon: "flame.fill", label: "Streak bonus (7-day)", amount: "+50", timestamp: "1h ago", positive: true),
    ActivityItem(id: 4, icon: "star.fill", label: "Clout milestone reached", amount: "+100", timestamp: "3h ago", positive: true),
    ActivityItem(id: 5, icon: "arrow.down.circle.fill", label: "Beacon tip from sage.xo", amount: "+12", timestamp: "5h ago", positive: true),
    ActivityItem(id: 6, icon: "arrow.up.circle.fill", label: "Location drop purchase", amount: "-30", timestamp: "8h ago", positive: false),
    ActivityItem(id: 7, icon: "gift.fill", label: "Daily login reward", amount: "+5", timestamp: "12h ago", positive: true),
    ActivityItem(id: 8, icon: "arrow.down.circle.fill", label: "Beacon tip from kaylafit", amount: "+8", timestamp: "1d ago", positive: true),
]

let sampleLeaders: [Leader] = [
    Leader(id: 1, rank: 1, name: "mira.wav", clout: 15800, verified: true),
    Leader(id: 2, rank: 2, name: "nyx.dream", clout: 12300, verified: true),
    Leader(id: 3, rank: 3, name: "kira.glow", clout: 11200, verified: true),
]
