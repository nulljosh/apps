import SwiftUI

struct GraphCanvasView: View {
    let equations: [Equation]

    // Transform state: scale = pixels per unit, offset = pan from center
    @State private var scale: CGFloat = 60
    @State private var offset: CGSize = .zero

    // Gesture tracking
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero

    private let bgColor = Color(hex: "0d0c0b")
    private let axisColor = Color.white.opacity(0.25)
    private let gridColor = Color.white.opacity(0.06)
    private let labelColor = Color.white.opacity(0.45)

    var body: some View {
        GeometryReader { geo in
            Canvas { ctx, size in
                drawGrid(ctx: ctx, size: size)
                drawAxes(ctx: ctx, size: size)
                drawLabels(ctx: ctx, size: size)
                drawEquations(ctx: ctx, size: size)
            }
            .background(bgColor)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let newScale = lastScale * value
                            scale = max(10, min(400, newScale))
                        }
                        .onEnded { value in
                            lastScale = scale
                        },
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
            )
        }
    }

    // MARK: - Drawing

    private func originX(size: CGSize) -> CGFloat { size.width / 2 + offset.width }
    private func originY(size: CGSize) -> CGFloat { size.height / 2 + offset.height }

    private func drawGrid(ctx: GraphicsContext, size: CGSize) {
        let cx = originX(size: size)
        let cy = originY(size: size)
        let step = scale

        var gridPath = Path()
        var x = (cx.truncatingRemainder(dividingBy: step) - step).truncatingRemainder(dividingBy: step)
        while x < size.width { gridPath.move(to: CGPoint(x: x, y: 0)); gridPath.addLine(to: CGPoint(x: x, y: size.height)); x += step }
        var y = (cy.truncatingRemainder(dividingBy: step) - step).truncatingRemainder(dividingBy: step)
        while y < size.height { gridPath.move(to: CGPoint(x: 0, y: y)); gridPath.addLine(to: CGPoint(x: size.width, y: y)); y += step }

        ctx.stroke(gridPath, with: .color(gridColor), lineWidth: 1)
    }

    private func drawAxes(ctx: GraphicsContext, size: CGSize) {
        let cx = originX(size: size)
        let cy = originY(size: size)
        var axes = Path()
        axes.move(to: CGPoint(x: 0, y: cy)); axes.addLine(to: CGPoint(x: size.width, y: cy))
        axes.move(to: CGPoint(x: cx, y: 0)); axes.addLine(to: CGPoint(x: cx, y: size.height))
        ctx.stroke(axes, with: .color(axisColor), lineWidth: 1.5)
    }

    private func drawLabels(ctx: GraphicsContext, size: CGSize) {
        let cx = originX(size: size)
        let cy = originY(size: size)
        let step = scale
        let labelStep = max(1.0, (80.0 / scale).rounded())
        let font = Font.system(size: 11)

        var xVal = (cx.truncatingRemainder(dividingBy: step) - step).truncatingRemainder(dividingBy: step)
        while xVal < size.width {
            let val = ((xVal - cx) / scale / labelStep).rounded() * labelStep
            if abs(val) > 0.001 {
                let text = Text(formatLabel(val)).font(font).foregroundColor(labelColor)
                ctx.draw(text, at: CGPoint(x: xVal, y: cy + 14), anchor: .top)
            }
            xVal += step
        }

        var yVal = (cy.truncatingRemainder(dividingBy: step) - step).truncatingRemainder(dividingBy: step)
        while yVal < size.height {
            let val = -((yVal - cy) / scale / labelStep).rounded() * labelStep
            if abs(val) > 0.001 {
                let text = Text(formatLabel(val)).font(font).foregroundColor(labelColor)
                ctx.draw(text, at: CGPoint(x: cx - 8, y: yVal), anchor: .trailing)
            }
            yVal += step
        }
    }

    private func formatLabel(_ v: Double) -> String {
        if v == v.rounded() && abs(v) < 1_000 { return String(Int(v)) }
        return String(format: "%.1f", v)
    }

    private func drawEquations(ctx: GraphicsContext, size: CGSize) {
        let cx = originX(size: size)
        let cy = originY(size: size)

        for eq in equations where eq.enabled && !eq.expression.isEmpty {
            var path = Path()
            var penDown = false
            let steps = Int(size.width)

            for px in 0..<steps {
                let xWorld = (CGFloat(px) - cx) / scale
                guard let yWorld = GraphMath.evaluate(eq.expression, at: Double(xWorld)) else {
                    penDown = false
                    continue
                }
                let py = cy - CGFloat(yWorld) * scale
                let point = CGPoint(x: CGFloat(px), y: py)
                if !penDown { path.move(to: point); penDown = true }
                else { path.addLine(to: point) }
            }

            ctx.stroke(path, with: .color(Color(hex: eq.color.dropFirst())), lineWidth: 2.2)
        }
    }
}

// MARK: - Color hex init

extension Color {
    init(hex: some StringProtocol) {
        var s = String(hex).trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s = String(s.dropFirst()) }
        if s.count == 3 { s = s.map { "\($0)\($0)" }.joined() }
        let val = UInt64(s, radix: 16) ?? 0
        let r = Double((val >> 16) & 0xff) / 255
        let g = Double((val >> 8) & 0xff) / 255
        let b = Double(val & 0xff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
