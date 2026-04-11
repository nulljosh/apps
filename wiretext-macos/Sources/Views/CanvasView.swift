import SwiftUI
import AppKit

struct CanvasView: NSViewRepresentable {
    @Environment(CanvasModel.self) private var canvas

    func makeNSView(context: Context) -> NSScrollView {
        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.backgroundColor = NSColor(hex: "#0d0d0d")
        scroll.scrollerStyle = .overlay

        let tv = CanvasTextView()
        tv.font = NSFont(name: "Menlo", size: 13) ?? NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        tv.textColor = NSColor(hex: "#e8e4da")
        tv.backgroundColor = NSColor(hex: "#0d0d0d")
        tv.isEditable = true
        tv.isRichText = false
        tv.isAutomaticQuoteSubstitutionEnabled = false
        tv.isAutomaticDashSubstitutionEnabled = false
        tv.isAutomaticSpellingCorrectionEnabled = false
        tv.isContinuousSpellCheckingEnabled = false
        tv.string = canvas.renderedText
        tv.canvasRef = canvas
        tv.textContainerInset = NSSize(width: 8, height: 8)
        tv.delegate = context.coordinator

        scroll.documentView = tv
        context.coordinator.textView = tv
        return scroll
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let tv = scrollView.documentView as? CanvasTextView else { return }
        tv.canvasRef = canvas
        if tv.string != canvas.renderedText {
            let sel = tv.selectedRange()
            tv.string = canvas.renderedText
            tv.setSelectedRange(sel)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(canvas: canvas) }

    class Coordinator: NSObject, NSTextViewDelegate {
        var canvas: CanvasModel
        weak var textView: CanvasTextView?

        init(canvas: CanvasModel) {
            self.canvas = canvas
        }

        func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            // Sync back to model when user directly edits text
            let lines = tv.string.components(separatedBy: "\n")
            for (r, line) in lines.prefix(CanvasModel.rows).enumerated() {
                for (c, ch) in line.prefix(CanvasModel.cols).enumerated() {
                    canvas.grid[r][c] = ch
                }
                // pad short lines
                if line.count < CanvasModel.cols {
                    for c in line.count..<CanvasModel.cols {
                        canvas.grid[r][c] = " "
                    }
                }
            }
            canvas.renderedText = canvas.render()
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            let loc = tv.selectedRange().location
            let text = tv.string as NSString
            let linesBefore = text.substring(to: min(loc, text.length))
                .components(separatedBy: "\n")
            canvas.cursorRow = linesBefore.count - 1
            canvas.cursorCol = linesBefore.last?.count ?? 0
        }
    }
}

class CanvasTextView: NSTextView {
    weak var canvasRef: CanvasModel?
    private var trackingArea: NSTrackingArea?

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let old = trackingArea { removeTrackingArea(old) }
        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseMoved, .activeInWindow, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override func mouseMoved(with event: NSEvent) {
        guard let model = canvasRef else { return }
        let pt = convert(event.locationInWindow, from: nil)
        let (col, row) = model.pixelToGrid(x: pt.x - textContainerInset.width, y: pt.y)
        model.hoveredCol = col
        model.hoveredRow = row
        if model.activeTool != nil {
            NSCursor.crosshair.set()
        } else {
            NSCursor.iBeam.set()
        }
    }

    override func mouseExited(with event: NSEvent) {
        guard let model = canvasRef else { return }
        model.hoveredCol = -1
        model.hoveredRow = -1
    }

    override func mouseDown(with event: NSEvent) {
        guard let model = canvasRef, let tool = model.activeTool else {
            super.mouseDown(with: event)
            return
        }
        let pt = convert(event.locationInWindow, from: nil)
        let (col, row) = model.pixelToGrid(x: pt.x - textContainerInset.width, y: pt.y)
        model.place(tool, col: col, row: row)
        model.activeTool = nil
        NSCursor.iBeam.set()
    }

    override func keyDown(with event: NSEvent) {
        // ESC cancels active tool
        if event.keyCode == 53, canvasRef?.activeTool != nil {
            canvasRef?.activeTool = nil
            return
        }
        super.keyDown(with: event)
    }

    // Draw ghost preview overlay when a tool is active
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let model = canvasRef,
              let tool = model.activeTool,
              model.hoveredCol >= 0, model.hoveredRow >= 0 else { return }

        let col = model.hoveredCol
        let row = model.hoveredRow
        let x = CGFloat(col) * CanvasModel.charW + textContainerInset.width
        let y = CGFloat(row) * CanvasModel.charH + textContainerInset.height
        let lines = tool.template.components(separatedBy: "\n")

        guard let font = self.font else { return }
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor(hex: "#3d9e6a").withAlphaComponent(0.6)
        ]
        for (dy, line) in lines.enumerated() {
            let pt = NSPoint(x: x, y: y + CGFloat(dy) * CanvasModel.charH)
            (line as NSString).draw(at: pt, withAttributes: attrs)
        }
    }
}

extension NSColor {
    convenience init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: h).scanHexInt64(&v)
        self.init(
            red: CGFloat((v >> 16) & 0xFF) / 255,
            green: CGFloat((v >> 8) & 0xFF) / 255,
            blue: CGFloat(v & 0xFF) / 255,
            alpha: 1
        )
    }
}
