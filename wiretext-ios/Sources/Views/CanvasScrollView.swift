import SwiftUI

struct CanvasScrollView: View {
    @Environment(CanvasModel.self) private var canvas

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            CanvasTextView()
                .environment(canvas)
                .frame(width: CGFloat(CanvasModel.cols) * 8.0, height: CGFloat(CanvasModel.rows) * 19.0)
        }
        .background(Color(hex: "#0f0f0f"))
    }
}

struct CanvasTextView: UIViewRepresentable {
    @Environment(CanvasModel.self) private var canvas

    func makeUIView(context: Context) -> UITextView {
        let tv = TapTextView()
        tv.backgroundColor = UIColor(hex: "#0f0f0f")
        tv.textColor = UIColor(hex: "#e8e4da")
        tv.font = UIFont(name: "Menlo", size: 13) ?? UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.text = canvas.renderedText
        tv.autocorrectionType = .no
        tv.canvasModel = canvas
        return tv
    }

    func updateUIView(_ tv: UITextView, context: Context) {
        if tv.text != canvas.renderedText { tv.text = canvas.renderedText }
    }
}

class TapTextView: UITextView {
    weak var canvasModel: CanvasModel?

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }

    @objc func handleTap(_ g: UITapGestureRecognizer) {
        guard let model = canvasModel, let tool = model.activeTool else { return }
        let pt = g.location(in: self)
        let col = Int(pt.x / 8.0), row = Int(pt.y / 19.0)
        model.place(tool, col: col, row: row)
        model.activeTool = nil
    }
}

extension UIColor {
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
