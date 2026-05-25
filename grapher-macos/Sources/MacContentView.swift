import SwiftUI
import AppKit

struct MacContentView: View {
    @State private var store = EquationStore()

    var body: some View {
        NavigationSplitView {
            MacEquationListView(store: store, onExport: exportPNG)
                .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 320)
        } detail: {
            MacGraphCanvasView(equations: store.equations)
                .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: .addEquation)) { _ in
            store.add()
        }
    }

    private func exportPNG() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "grapher-export.png"
        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            let renderer = ImageRenderer(content:
                MacGraphCanvasView(equations: store.equations)
                    .frame(width: 1080, height: 1080)
            )
            renderer.scale = 2
            if let cgImg = renderer.cgImage {
                let bmp = NSBitmapImageRep(cgImage: cgImg)
                if let data = bmp.representation(using: .png, properties: [:]) {
                    try? data.write(to: url)
                }
            }
        }
    }
}
