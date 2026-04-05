import Foundation
import SwiftData

@Model
final class Reward {
    var id: UUID
    var text: String
    var active: Bool

    init(text: String) {
        self.id = UUID()
        self.text = text
        self.active = true
    }
}
