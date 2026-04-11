import SwiftUI

struct ToolbarSidebar: View {
    @Environment(CanvasModel.self) private var canvas
    let categories = ["Input", "Layout", "Display"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("wiretext")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(categories, id: \.self) { cat in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cat.uppercased())
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Color(hex: "#3d9e6a"))
                                .padding(.horizontal, 12).padding(.top, 8)
                            ForEach(ComponentType.allCases.filter { $0.category == cat }) { type in
                                ComponentRow(type: type, isActive: canvas.activeTool == type) {
                                    canvas.activeTool = canvas.activeTool == type ? nil : type
                                }
                            }
                        }
                    }
                }
            }
            Divider()
            VStack(spacing: 2) {
                SidebarButton("Export as Text", action: canvas.exportText)
                SidebarButton("Copy to Clipboard", action: canvas.copyToClipboard)
                SidebarButton("Clear Canvas", action: canvas.clear, danger: true)
            }
            .padding(8)
        }
        .background(Color(hex: "#161616"))
    }
}

struct ComponentRow: View {
    let type: ComponentType
    let isActive: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(type.unicodeIcon)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(isActive ? Color(hex: "#3d9e6a") : .secondary)
                    .frame(width: 32, alignment: .leading)
                Text(type.displayName)
                    .font(.system(size: 12))
                    .foregroundStyle(isActive ? .white : Color(hex: "#aaaaaa"))
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 4)
            .background(isActive ? Color(hex: "#1a2e20") : .clear)
            .cornerRadius(3)
        }
        .buttonStyle(.plain)
    }
}

struct SidebarButton: View {
    let label: String
    let action: () -> Void
    var danger = false
    init(_ label: String, action: @escaping () -> Void, danger: Bool = false) {
        self.label = label; self.action = action; self.danger = danger
    }
    var body: some View {
        Button(action: action) {
            Text(label).font(.system(size: 11))
                .foregroundStyle(danger ? Color(hex: "#c0392b") : Color(hex: "#888888"))
                .frame(maxWidth: .infinity).padding(.vertical, 5)
        }
        .buttonStyle(.plain)
    }
}
