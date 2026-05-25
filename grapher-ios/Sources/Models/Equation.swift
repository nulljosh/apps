import Foundation

struct Equation: Identifiable, Codable, Sendable {
    var id = UUID()
    var expression: String
    var color: String = "#FF851B"
    var enabled: Bool = true
}
