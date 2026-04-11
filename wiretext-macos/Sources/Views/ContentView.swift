import SwiftUI

struct ContentView: View {
    @Environment(CanvasModel.self) private var canvas

    var body: some View {
        HSplitView {
            ToolbarSidebar()
                .frame(minWidth: 180, maxWidth: 200)
            CanvasView()
            InspectorSidebar()
                .frame(minWidth: 160, maxWidth: 180)
        }
        .background(Color(hex: "#0f0f0f"))
    }
}
