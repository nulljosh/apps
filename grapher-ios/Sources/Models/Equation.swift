import Foundation

struct Equation: Identifiable, Codable, Sendable {
    var id = UUID()
    var expression: String
    var color: String = "#0071e3"
    var enabled: Bool = true
}
