import SwiftUI

struct ToolbarSidebar: View {
    @Environment(CanvasModel.self) private var canvas
    @State private var search = ""
    let categories = ["Input", "Layout", "Display"]

    var filteredTypes: [ComponentType] {
        guard !search.isEmpty else { return ComponentType.allCases }
        return ComponentType.allCases.filter {
            $0.displayName.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 6) {
                Text("wiretext")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Color(hex: "#e8e4da"))
                Spacer()
                if canvas.activeTool != nil {
                    Button {
                        canvas.activeTool = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(hex: "#3d9e6a"))
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .help("Cancel (Esc)")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            // Search
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(hex: "#4a6e50"))
                TextField("Search...", text: $search)
                    .font(.system(size: 11))
                    .textFieldStyle(.plain)
                if !search.isEmpty {
                    Button { search = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#4a6e50"))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color(hex: "#1a2e20"))
            .cornerRadius(5)
            .padding(.horizontal, 8)
            .padding(.bottom, 4)

            Divider()
                .background(Color(hex: "#1f1f1f"))

            // Component list
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if search.isEmpty {
                        ForEach(categories, id: \.self) { cat in
                            categorySection(cat)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(filteredTypes) { type in
                                ComponentRow(type: type, isActive: canvas.activeTool == type) {
                                    canvas.activeTool = canvas.activeTool == type ? nil : type
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.bottom, 8)
            }

            Divider()
                .background(Color(hex: "#1f1f1f"))

            // Bottom actions
            VStack(spacing: 1) {
                SidebarButton("Copy to Clipboard", icon: "doc.on.doc", action: canvas.copyToClipboard)
                SidebarButton("Export as Text...", icon: "square.and.arrow.up", action: canvas.exportText)
                SidebarButton("Undo", icon: "arrow.uturn.backward") { canvas.undo() }
                    .opacity(canvas.canUndo ? 1 : 0.35)
                SidebarButton("Clear Canvas", icon: "trash", action: canvas.clear, danger: true)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color(hex: "#141414"))
    }

    private func categorySection(_ cat: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(cat.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color(hex: "#3d9e6a"))
                .padding(.horizontal, 12)
                .padding(.top, 10)
            ForEach(ComponentType.allCases.filter { $0.category == cat }) { type in
                ComponentRow(type: type, isActive: canvas.activeTool == type) {
                    canvas.activeTool = canvas.activeTool == type ? nil : type
                }
            }
        }
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
                    .foregroundStyle(isActive ? Color(hex: "#3d9e6a") : Color(hex: "#555555"))
                    .frame(width: 32, alignment: .leading)
                Text(type.displayName)
                    .font(.system(size: 12))
                    .foregroundStyle(isActive ? Color(hex: "#e8e4da") : Color(hex: "#999999"))
                Spacer()
                if isActive {
                    Image(systemName: "cursorarrow.click")
                        .font(.system(size: 9))
                        .foregroundStyle(Color(hex: "#3d9e6a").opacity(0.7))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                isActive
                    ? Color(hex: "#1a2e20")
                    : Color.clear
            )
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
    }
}

struct SidebarButton: View {
    let label: String
    var icon: String = ""
    let action: () -> Void
    var danger = false

    init(_ label: String, icon: String = "", action: @escaping () -> Void, danger: Bool = false) {
        self.label = label
        self.icon = icon
        self.action = action
        self.danger = danger
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if !icon.isEmpty {
                    Image(systemName: icon)
                        .font(.system(size: 10))
                }
                Text(label)
                    .font(.system(size: 11))
                Spacer()
            }
            .foregroundStyle(danger ? Color(hex: "#c0392b") : Color(hex: "#777777"))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
