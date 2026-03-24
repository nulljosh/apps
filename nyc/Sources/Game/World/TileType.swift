import AppKit

enum TileType: Int, Codable, Sendable {
    case road
    case sidewalk
    case building
    case billboard
    case subway
    case sewer
    case empty

    var rawString: String {
        switch self {
        case .road: "road"
        case .sidewalk: "sidewalk"
        case .building: "building"
        case .billboard: "billboard"
        case .subway: "subway"
        case .sewer: "sewer"
        case .empty: "empty"
        }
    }

    var isWalkable: Bool {
        switch self {
        case .road, .sidewalk, .subway: true
        case .building, .billboard, .sewer, .empty: false
        }
    }

    var baseColor: NSColor {
        switch self {
        case .road: NSColor(red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        case .sidewalk: NSColor(red: 0.35, green: 0.35, blue: 0.4, alpha: 1)
        case .building: NSColor(red: 0.05, green: 0.11, blue: 0.16, alpha: 1)
        case .billboard: NSColor(red: 0.97, green: 0.15, blue: 0.52, alpha: 1)
        case .subway: NSColor(red: 1.0, green: 0.9, blue: 0.43, alpha: 1)
        case .sewer: NSColor(red: 0.2, green: 0.25, blue: 0.2, alpha: 1)
        case .empty: NSColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1)
        }
    }

    var resourceYield: ResourceType? {
        switch self {
        case .subway: .cash
        case .sewer: .materials
        default: nil
        }
    }
}
