import SwiftUI

struct ComponentPickerView: View {
    @Environment(CanvasModel.self) private var canvas
    @Environment(\.dismiss) private var dismiss
    let cols = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let cats = ["Input", "Layout", "Display"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(cats, id: \.self) { cat in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(cat.uppercased())
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(Color(hex: "#3d9e6a"))
                                .padding(.horizontal)
                            LazyVGrid(columns: cols, spacing: 8) {
                                ForEach(ComponentType.allCases.filter { $0.category == cat }) { t in
                                    Button { canvas.activeTool = t; dismiss() } label: {
                                        VStack(spacing: 6) {
                                            Text(t.unicodeIcon)
                                                .font(.system(size: 16, design: .monospaced))
                                                .foregroundStyle(Color(hex: "#3d9e6a"))
                                            Text(t.displayName).font(.system(size: 11)).foregroundStyle(.secondary)
                                        }
                                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                                        .background(Color(hex: "#1a2e20")).cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(hex: "#0c1a12"))
            .navigationTitle("Add Component")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }
}
