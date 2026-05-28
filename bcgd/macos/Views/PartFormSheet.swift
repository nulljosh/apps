import SwiftUI

struct PartFormSheet: View {
    let part: PartData?
    let onSave: (PartData) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""; @State private var sku = ""
    @State private var category = "Other"; @State private var quantity = 0
    @State private var minThreshold = 2; @State private var cost = ""; @State private var supplier = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    TextField("SKU", text: $sku)
                    Picker("Category", selection: $category) { ForEach(CATEGORIES, id: \.self) { Text($0) } }
                    TextField("Supplier", text: $supplier)
                }
                Section("Stock") {
                    Stepper("Qty: \(quantity)", value: $quantity, in: 0...9999)
                    Stepper("Min: \(minThreshold)", value: $minThreshold, in: 0...999)
                    TextField("Unit cost ($)", text: $cost)
                }
            }
            .frame(minWidth: 420, minHeight: 360)
            .navigationTitle(part == nil ? "Add Part" : "Edit Part")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(PartData(id: part?.id ?? UUID().uuidString, name: name, sku: sku,
                            category: category, quantity: quantity, minThreshold: minThreshold,
                            cost: Double(cost) ?? 0, supplier: supplier))
                        dismiss()
                    }.disabled(name.isEmpty)
                }
            }
            .onAppear { if let p = part {
                name = p.name; sku = p.sku; category = p.category
                quantity = p.quantity; minThreshold = p.minThreshold
                cost = p.cost > 0 ? String(format: "%.2f", p.cost) : ""; supplier = p.supplier
            }}
        }
    }
}
