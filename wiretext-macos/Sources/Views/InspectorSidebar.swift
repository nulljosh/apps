import SwiftUI

struct InspectorSidebar: View {
    @Environment(CanvasModel.self) private var canvas

    private var charCount: Int {
        canvas.grid.reduce(0) { acc, row in
            acc + row.filter { $0 != " " }.count
        }
    }

    private var usedRows: Int {
        var last = 0
        for (i, row) in canvas.grid.enumerated() {
            if row.contains(where: { $0 != " " }) { last = i + 1 }
        }
        return last
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("INSPECTOR")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color(hex: "#3d9e6a"))
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 6)

            Divider()
                .background(Color(hex: "#1f1f1f"))

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    InspectorSection(title: "Canvas") {
                        InspectorRow("Width", "\(CanvasModel.cols) cols")
                        InspectorRow("Height", "\(CanvasModel.rows) rows")
                        InspectorRow("Char W", "\(CanvasModel.charW, specifier: "%.1f")px")
                        InspectorRow("Char H", "\(CanvasModel.charH, specifier: "%.1f")px")
                    }

                    InspectorSection(title: "Content") {
                        InspectorRow("Chars used", "\(charCount)")
                        InspectorRow("Rows used", "\(usedRows)")
                        InspectorRow("History", "\(canvas.canUndo ? "can undo" : "at start")")
                    }

                    InspectorSection(title: "Cursor") {
                        InspectorRow("Row", "\(canvas.cursorRow)")
                        InspectorRow("Col", "\(canvas.cursorCol)")
                        if canvas.hoveredCol >= 0 {
                            InspectorRow("Hover col", "\(canvas.hoveredCol)")
                            InspectorRow("Hover row", "\(canvas.hoveredRow)")
                        }
                    }

                    if let tool = canvas.activeTool {
                        InspectorSection(title: "Active Tool") {
                            InspectorRow("Name", tool.displayName)
                            InspectorRow("Rows", "\(tool.templateRows)")
                            InspectorRow("Cols", "\(tool.templateCols)")
                        }
                    }

                    InspectorSection(title: "Shortcuts") {
                        InspectorRow("Undo", "⌘Z")
                        InspectorRow("Redo", "⌘⇧Z")
                        InspectorRow("Copy", "⌘⇧C")
                        InspectorRow("Export", "⌘E")
                        InspectorRow("Cancel", "Esc")
                    }
                }
                .padding(12)
            }

            Spacer(minLength: 0)
        }
        .background(Color(hex: "#141414"))
    }
}

struct InspectorSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color(hex: "#3d9e6a"))
                .padding(.bottom, 1)
            content()
        }
    }
}

struct InspectorRow: View {
    let label: String
    let value: String

    init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "#666666"))
            Spacer()
            Text(value)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Color(hex: "#c8c4bc"))
        }
    }
}
