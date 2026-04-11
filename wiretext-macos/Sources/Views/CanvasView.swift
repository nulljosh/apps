import SwiftUI
import AppKit

struct CanvasView: NSViewRepresentable {
    @Environment(CanvasModel.self) private var canvas

    func makeNSView(context: Context) -> NSScrollView {
        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.backgroundColor = .black

        let tv = CanvasTextView()
        tv.font = NSFont(name: "Menlo", size: 13) ?? NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        tv.textColor = NSColor(hex: "#e8e4da")
        tv.backgroundColor = NSColor(hex: "#0f0f0f")
        tv.isEditable = true
        tv.isRichText = false
        tv.isAutomaticQuoteSubstitutionEnabled = false
        tv.isAutomaticDashSubstitutionEnabled = false
        tv.string = canvas.renderedText
        tv.canvasRef = canvas

        scroll.documentView = tv
        context.coordinator.textView = tv
        return scroll
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let tv = scrollView.documentView as? CanvasTextView else { return }
        if tv.string != canvas.renderedText { tv.string = canvas.renderedText }
    }

    func makeCoordinator() -> Coordinator { Coordinator(canvas: canvas) }

    class Coordinator: NSObject {
        var canvas: CanvasModel
        weak var textView: CanvasTextView?
        init(canvas: CanvasModel) { self.canvas = canvas }
    }
}

class CanvasTextView: NSTextView {
    weak var canvasRef: CanvasModel?

    override func mouseDown(with event: NSEvent) {
        guard let model = canvasRef, let tool = model.activeTool else {
            super.mouseDown(with: event); return
        }
        let pt = convert(event.locationInWindow, from: nil)
        let (col, row) = model.pixelToGrid(x: pt.x, y: pt.y)
        model.place(tool, col: col, row: row)
    }
}

extension NSColor {
    convenience init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0; Scanner(string: h).scanHexInt64(&v)
        self.init(red: CGFloat((v>>16)&0xFF)/255, green: CGFloat((v>>8)&0xFF)/255, blue: CGFloat(v&0xFF)/255, alpha: 1)
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0; Scanner(string: h).scanHexInt64(&v)
        self.init(red: Double((v>>16)&0xFF)/255, green: Double((v>>8)&0xFF)/255, blue: Double(v&0xFF)/255)
    }
}
