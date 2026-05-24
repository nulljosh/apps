import SwiftUI

struct StampView: View {
    let caseID: CaseID
    var size: CGFloat = 95

    var body: some View {
        Canvas { ctx, sz in
            let s  = sz.width / 132
            let cx = sz.width / 2
            let cy = sz.height / 2

            let outerR = 58 * s
            let innerR = 50 * s
            let textR  = 53 * s

            ctx.stroke(
                Path(ellipseIn: CGRect(x: cx - outerR, y: cy - outerR, width: outerR * 2, height: outerR * 2)),
                with: .color(.briefDanger), lineWidth: 1.8 * s
            )
            ctx.stroke(
                Path(ellipseIn: CGRect(x: cx - innerR, y: cy - innerR, width: innerR * 2, height: innerR * 2)),
                with: .color(.briefDanger), lineWidth: s
            )

            let fs  = 9 * s
            let spc = 2.2 * s

            // Top arc: θ from π → 2π (left → top → right, counter-clockwise through top)
            arcText(ctx: ctx, cx: cx, cy: cy, r: textR,
                    text: "PRE-LITIGATION · BRIEF VOL. I",
                    start: .pi, span: .pi, dir: 1, fs: fs, spc: spc)

            // Bottom arc: θ from π → 0 (left → bottom → right, direction -1)
            let botText: String
            switch caseID {
            case .rcmp:   botText = "CASE-0001 · BC · CAN"
            case .family: botText = "CASE-0002 · BC · CAN"
            case .muni:   botText = "CASE-0003 · BC · CAN"
            }
            arcText(ctx: ctx, cx: cx, cy: cy, r: textR,
                    text: botText,
                    start: .pi, span: .pi, dir: -1, fs: fs, spc: spc)

            let (line1, line2, fs1): (String, String, CGFloat) = {
                switch caseID {
                case .rcmp:   return ("trommel",  "v. AG CAN",   15 * s)
                case .family: return ("trommel",  "v. trommel",  13 * s)
                case .muni:   return ("baitz",    "v. surrey",   15 * s)
                }
            }()

            ctx.draw(
                Text(line1)
                    .font(.system(size: fs1, weight: .medium, design: .default).italic())
                    .foregroundStyle(Color.briefDanger),
                at: CGPoint(x: cx, y: cy - 5 * s), anchor: .center
            )
            ctx.draw(
                Text(line2)
                    .font(.system(size: 7.5 * s, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.briefDanger),
                at: CGPoint(x: cx, y: cy + 9 * s), anchor: .center
            )
        }
        .frame(width: size, height: size)
        .opacity(0.55)
    }

    private func arcText(ctx: GraphicsContext, cx: CGFloat, cy: CGFloat, r: CGFloat,
                         text: String, start: CGFloat, span: CGFloat, dir: CGFloat,
                         fs: CGFloat, spc: CGFloat) {
        let chars = Array(text)
        guard !chars.isEmpty else { return }
        let cw = fs * 0.56
        let totalW = CGFloat(chars.count) * cw + CGFloat(chars.count - 1) * spc
        let arcLen = r * span
        var off = (arcLen - totalW) / 2 + cw / 2

        for ch in chars {
            let θ = start + dir * (off / arcLen) * span
            let x = cx + r * cos(θ)
            let y = cy + r * sin(θ)
            let rot = θ + dir * .pi / 2
            let t = CGAffineTransform(a: cos(rot), b: sin(rot),
                                       c: -sin(rot), d: cos(rot),
                                       tx: x, ty: y)
            var c = ctx
            c.concatenate(t)
            c.draw(
                Text(String(ch))
                    .font(.system(size: fs, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.briefDanger),
                at: .zero, anchor: .center
            )
            off += cw + spc
        }
    }
}
