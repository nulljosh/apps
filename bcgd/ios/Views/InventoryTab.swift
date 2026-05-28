import SwiftUI
import SwiftData

struct InventoryTab: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Part.name) private var parts: [Part]
    @State private var search = ""
    @State private var catFilter = "All"
    @State private var editing: Part?
    @State private var showAdd = false

    private var filtered: [Part] {
        parts.filter {
            (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
             || $0.sku.localizedCaseInsensitiveContains(search)
             || $0.supplier.localizedCaseInsensitiveContains(search))
            && (catFilter == "All" || $0.category == catFilter)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filtered) { p in
                    PartRow(part: p).onTapGesture { editing = p }
                }
                .onDelete { idx in idx.forEach { context.delete(filtered[$0]) } }
            }
            .searchable(text: $search, prompt: "Name, SKU, supplier")
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("All") { catFilter = "All" }
                        Divider()
                        ForEach(CATEGORIES, id: \.self) { cat in Button(cat) { catFilter = cat } }
                    } label: { Label(catFilter, systemImage: "line.3.horizontal.decrease.circle") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAdd = true } label: { Image(systemName: "plus") }
                }
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
        }
    }
}

struct PartRow: View {
    let part: Part
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(part.name).font(.subheadline.weight(.medium))
                    if part.isOutOfStock {
                        badge("OUT", .red)
                    } else if part.isLowStock {
                        badge("LOW", .orange)
                    }
                }
                Text(part.sku).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 10) {
                Button { part.quantity = max(0, part.quantity - 1) } label: {
                    Image(systemName: "minus.circle").font(.title3)
                }
                .buttonStyle(.plain).foregroundStyle(.secondary)

                Text("\(part.quantity)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(part.isOutOfStock ? .red : part.isLowStock ? .orange : .primary)
                    .frame(minWidth: 28, alignment: .center)

                Button { part.quantity += 1 } label: {
                    Image(systemName: "plus.circle").font(.title3)
                }
                .buttonStyle(.plain).foregroundStyle(Color(hex: "0071e3"))
            }
        }
        .padding(.vertical, 4)
    }

    func badge(_ text: String, _ color: Color) -> some View {
        Text(text).font(.caption.bold())
            .padding(.horizontal, 5).padding(.vertical, 1)
            .background(color.opacity(0.2)).foregroundStyle(color).clipShape(.capsule)
    }
}
