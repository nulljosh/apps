import SwiftUI

struct InspectorSidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("INSPECTOR")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color(hex: "#3d9e6a"))
                .padding(.horizontal, 12).padding(.top, 12).padding(.bottom, 4)
            Divider()
            VStack(alignment: .leading, spacing: 16) {
                InspectorSection(title: "Canvas") {
                    InspectorRow("Width", "120 cols")
                    InspectorRow("Height", "60 rows")
                }
                InspectorSection(title: "Layers") {
                    InspectorRow("Layer 1", "")
                }
            }
            .padding(12)
            Spacer()
        }
        .background(Color(hex: "#161616"))
    }
}

struct InspectorSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold)).foregroundStyle(Color(hex: "#3d9e6a"))
            content()
        }
    }
}

struct InspectorRow: View {
    let label: String; let value: String
    init(_ label: String, _ value: String) { self.label = label; self.value = value }
    var body: some View {
        HStack {
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary)
            Spacer()
            Text(value).font(.system(size: 11, design: .monospaced)).foregroundStyle(.white)
        }
    }
}
