import SwiftUI

struct ComponentPickerView: View {
    @Environment(CanvasModel.self) private var canvas
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""

    let cols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let cats = ["Input", "Layout", "Display"]

    var filteredTypes: [ComponentType] {
        guard !search.isEmpty else { return ComponentType.allCases }
        return ComponentType.allCases.filter {
            $0.displayName.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $search)
                    .padding(.horizontal)
                    .padding(.top, 8)

                ScrollView {
                    if search.isEmpty {
                        categorizedGrid
                    } else {
                        flatGrid(types: filteredTypes)
                    }
                }
            }
            .background(Color(hex: "#0c1a12"))
            .navigationTitle("Components")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var categorizedGrid: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(cats, id: \.self) { cat in
                VStack(alignment: .leading, spacing: 8) {
                    Text(cat.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color(hex: "#3d9e6a"))
                        .padding(.horizontal)
                    flatGrid(types: ComponentType.allCases.filter { $0.category == cat })
                }
            }
        }
        .padding(.vertical)
    }

    private func flatGrid(types: [ComponentType]) -> some View {
        LazyVGrid(columns: cols, spacing: 8) {
            ForEach(types) { t in
                ComponentTile(type: t) {
                    canvas.activeTool = t
                    dismiss()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ComponentTile: View {
    let type: ComponentType
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(type.unicodeIcon)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(Color(hex: "#3d9e6a"))
                Text(type.displayName)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: "#c8c4bc"))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#152318"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color(hex: "#2a4530"), lineWidth: 1)
                    )
            )
            .scaleEffect(pressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: pressed)
        }
        .buttonStyle(.plain)
        ._onButtonGesture { p in pressed = p } perform: {}
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(hex: "#4a6e50"))
                .font(.system(size: 13))
            TextField("Search components...", text: $text)
                .font(.system(size: 14))
                .foregroundStyle(Color(hex: "#e8e4da"))
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(hex: "#4a6e50"))
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#152318"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color(hex: "#2a4530"), lineWidth: 1)
                )
        )
    }
}
