import SwiftUI

struct ContentView: View {
    @Environment(CanvasModel.self) private var canvas

    var body: some View {
        HSplitView {
            ToolbarSidebar()
                .frame(minWidth: 175, maxWidth: 200)
            CanvasView()
            InspectorSidebar()
                .frame(minWidth: 160, maxWidth: 185)
        }
        .background(Color(hex: "#0d0d0d"))
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: h).scanHexInt64(&v)
        self.init(
            red: Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8) & 0xFF) / 255,
            blue: Double(v & 0xFF) / 255
        )
    }
}
