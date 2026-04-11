import SwiftUI

struct CanvasScrollView: View {
    @Environment(CanvasModel.self) private var canvas

    private let canvasW = CGFloat(CanvasModel.cols) * CanvasModel.charW
    private let canvasH = CGFloat(CanvasModel.rows) * CanvasModel.charH

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            CanvasTextView()
                .environment(canvas)
                .frame(width: canvasW, height: canvasH)
                .overlay(alignment: .topLeading) {
                    if let tool = canvas.activeTool {
                        GhostOverlay(tool: tool)
                            .environment(canvas)
                            .allowsHitTesting(false)
                    }
                }
        }
        .background(Color(hex: "#0c0c0c"))
    }
}

/// Floating ghost preview that follows the last touch location
struct GhostOverlay: View {
    @Environment(CanvasModel.self) private var canvas
    let tool: ComponentType

    var body: some View {
        let col = canvas.cursorCol
        let row = canvas.cursorRow
        let x = CGFloat(col) * CanvasModel.charW
        let y = CGFloat(row) * CanvasModel.charH
        let lines = tool.template.components(separatedBy: "\n")
        let w = CGFloat(tool.templateCols) * CanvasModel.charW
        let h = CGFloat(tool.templateRows) * CanvasModel.charH

        Text(tool.template)
            .font(Font.custom("Menlo", size: 13).monospaced())
            .foregroundStyle(Color(hex: "#3d9e6a").opacity(0.55))
            .frame(width: w, height: h, alignment: .topLeading)
            .fixedSize()
            .offset(x: x, y: y)
            .allowsHitTesting(false)
        let _ = lines  // silence unused warning
    }
}

struct CanvasTextView: UIViewRepresentable {
    @Environment(CanvasModel.self) private var canvas

    func makeUIView(context: Context) -> UITextView {
        let tv = TapTextView()
        tv.backgroundColor = UIColor(hex: "#0c0c0c")
        tv.textColor = UIColor(hex: "#e8e4da")
        tv.font = UIFont(name: "Menlo", size: 13) ?? UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.text = canvas.renderedText
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.canvasModel = canvas
        tv.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 24, right: 8)
        return tv
    }

    func updateUIView(_ tv: UITextView, context: Context) {
        if let tapView = tv as? TapTextView {
            tapView.canvasModel = canvas
        }
        if tv.text != canvas.renderedText {
            tv.text = canvas.renderedText
        }
    }
}

class TapTextView: UITextView {
    weak var canvasModel: CanvasModel?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    @objc func handleTap(_ g: UITapGestureRecognizer) {
        guard let model = canvasModel else { return }
        let pt = g.location(in: self)
        let col = Int((pt.x - contentInset.left) / CanvasModel.charW)
        let row = Int((pt.y - contentInset.top) / CanvasModel.charH)
        model.cursorCol = max(0, min(col, CanvasModel.cols - 1))
        model.cursorRow = max(0, min(row, CanvasModel.rows - 1))
        guard let tool = model.activeTool else { return }
        model.place(tool, col: col, row: row)
        model.activeTool = nil
    }

    @objc func handlePan(_ g: UIPanGestureRecognizer) {
        guard let model = canvasModel else { return }
        let pt = g.location(in: self)
        let col = Int((pt.x - contentInset.left) / CanvasModel.charW)
        let row = Int((pt.y - contentInset.top) / CanvasModel.charH)
        model.cursorCol = max(0, min(col, CanvasModel.cols - 1))
        model.cursorRow = max(0, min(row, CanvasModel.rows - 1))

        guard g.state == .ended, let tool = model.activeTool else { return }
        model.place(tool, col: col, row: row)
        model.activeTool = nil
    }
}

extension UIColor {
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
