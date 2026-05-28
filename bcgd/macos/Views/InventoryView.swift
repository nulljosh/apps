import SwiftUI
import SwiftData

struct InventoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Part.name) private var parts: [Part]
    @State private var search = ""
    @State private var catFilter = "All"
    @State private var editing: Part?
    @State private var showAdd = false

    private var filtered: [Part] {
        parts.filter {
            (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
             || $0.sku.localizedCaseInsensitiveContains(search))
            && (catFilter == "All" || $0.category == catFilter)
        }
    }

    var body: some View {
        Table(filtered) {
            TableColumn("Name") { p in
                HStack(spacing: 6) {
                    Text(p.name)
                    if p.isOutOfStock { badge("OUT", .red) }
                    else if p.isLowStock { badge("LOW", .orange) }
                }
            }
            TableColumn("SKU") { Text($0.sku).font(.system(.body, design: .monospaced)) }
            TableColumn("Category") { Text($0.category) }
            TableColumn("Qty") { p in
                HStack(spacing: 8) {
                    Button { p.quantity = max(0, p.quantity - 1) } label: { Image(systemName: "minus.circle") }.buttonStyle(.plain)
                    Text("\(p.quantity)").monospacedDigit().frame(minWidth: 28, alignment: .center)
                        .foregroundStyle(p.isOutOfStock ? .red : p.isLowStock ? .orange : .primary)
                    Button { p.quantity += 1 } label: { Image(systemName: "plus.circle") }.buttonStyle(.plain)
                        .foregroundStyle(Color(hex: "0071e3"))
                }
            }
            TableColumn("Min") { Text("\($0.minThreshold)") }
            TableColumn("Cost") { Text($0.cost > 0 ? "$\(String(format: "%.2f", $0.cost))" : "—") }
            TableColumn("Supplier") { Text($0.supplier) }
        }
        .searchable(text: $search, prompt: "Search parts, SKUs...")
        .navigationTitle("Inventory (\(filtered.count))")
        .toolbar {
            ToolbarItem {
                Menu {
                    Button("All") { catFilter = "All" }
                    Divider()
                    ForEach(CATEGORIES, id: \.self) { cat in Button(cat) { catFilter = cat } }
                } label: { Label(catFilter, systemImage: "line.3.horizontal.decrease.circle") }
            }
            ToolbarItem { Button("Add Part") { showAdd = true } }
        }
        .sheet(isPresented: $showAdd) {
            PartFormSheet(part: nil) { context.insert(Part.from($0)) }
        }
        .sheet(item: $editing) { p in
            PartFormSheet(part: p.data) { d in
                p.name = d.name; p.sku = d.sku; p.category = d.category
                p.quantity = d.quantity; p.minThreshold = d.minThreshold
                p.cost = d.cost; p.supplier = d.supplier
            }
        }
        .onDeleteCommand { /* handled via context menu */ }
    }

    func badge(_ t: String, _ c: Color) -> some View {
        Text(t).font(.caption.bold())
            .padding(.horizontal, 5).padding(.vertical, 1)
            .background(c.opacity(0.2)).foregroundStyle(c).clipShape(.capsule)
    }
}
