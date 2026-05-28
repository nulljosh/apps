import SwiftData
import Foundation

let CATEGORIES = [
    "Springs", "Cables", "Rollers", "Hinges", "Tracks",
    "Openers", "Remotes & Keypads", "Panels", "Weather Strips", "Hardware", "Other",
]

@Model final class Part {
    var id: String
    var name: String
    var sku: String
    var category: String
    var quantity: Int
    var minThreshold: Int
    var cost: Double
    var supplier: String

    init(id: String = UUID().uuidString, name: String, sku: String = "",
         category: String = "Other", quantity: Int = 0, minThreshold: Int = 2,
         cost: Double = 0, supplier: String = "") {
        self.id = id; self.name = name; self.sku = sku; self.category = category
        self.quantity = quantity; self.minThreshold = minThreshold
        self.cost = cost; self.supplier = supplier
    }

    var isLowStock: Bool { quantity <= minThreshold }
    var isOutOfStock: Bool { quantity == 0 }
    var totalValue: Double { Double(quantity) * cost }
}

struct PartData: Codable {
    var id: String; var name: String; var sku: String; var category: String
    var quantity: Int; var minThreshold: Int; var cost: Double; var supplier: String
}

extension Part {
    var data: PartData {
        PartData(id: id, name: name, sku: sku, category: category,
                 quantity: quantity, minThreshold: minThreshold, cost: cost, supplier: supplier)
    }
    static func from(_ d: PartData) -> Part {
        Part(id: d.id, name: d.name, sku: d.sku, category: d.category,
             quantity: d.quantity, minThreshold: d.minThreshold, cost: d.cost, supplier: d.supplier)
    }
}
