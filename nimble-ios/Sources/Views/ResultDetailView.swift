import SwiftUI

struct ResultDetailView: View {
    let result: QueryResult
    let accent: Color
    let queryText: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                detail
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .tint(accent)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                copyToolbarButton
            }
        }
    }

    private var title: String {
        switch result {
        case .math: "Result"
        case .text(let h, _, _, _, _): h ?? "Answer"
        case .list: "List"
        case .color(let hex): "#\(hex.uppercased())"
        case .convert: "Convert"
        case .error: "No Result"
        default: ""
        }
    }

    @ViewBuilder
    private var detail: some View {
        switch result {
        case .math(let v):
            mathDetail(v)
        case .text(let h, let b, let src, let srcURL, let imgURL):
            textDetail(heading: h, body: b, source: src, sourceURL: srcURL, imageURL: imgURL)
        case .list(let items, let src):
            listDetail(items: items, source: src)
        case .color(let hex):
            colorDetail(hex)
        case .convert(let f, let t, let fu, let tu):
            convertDetail(from: f, to: t, fromUnit: fu, toUnit: tu)
        case .error(let msg, let url):
            errorDetail(message: msg, searchURL: url)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var copyToolbarButton: some View {
        let text = copyableText
        if !text.isEmpty {
            Button(action: { copy(text) }) {
                Image(systemName: "doc.on.doc")
            }
        }
    }

    private var copyableText: String {
        switch result {
        case .math(let v): v
        case .text(_, let b, _, _, _): b
        case .list(let items, _): items.joined(separator: "\n")
        case .color(let hex): "#\(hex.uppercased())"
        case .convert(let f, let t, let fu, let tu): "\(f) \(fu) = \(t) \(tu)"
        default: ""
        }
    }

    private func copy(_ text: String) {
        UIPasteboard.general.string = text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// MARK: - Math

private extension ResultDetailView {
    func mathDetail(_ value: String) -> some View {
        VStack(spacing: 16) {
            Text(value)
                .font(.system(size: 60, weight: .semibold))
                .foregroundStyle(accent)
                .textSelection(.enabled)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.4)
            Text("RESULT")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.tertiary)
                .tracking(1.5)
            if !queryText.isEmpty {
                Text(queryText)
                    .font(.system(size: 13))
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
    }
}

// MARK: - Text

private extension ResultDetailView {
    func textDetail(heading: String?, body: String, source: String, sourceURL: String?, imageURL: String?) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        image.resizable().aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                            .clipped()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 16)
            }

            if let heading, !heading.isEmpty {
                Text(heading)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
                    .padding(.bottom, 10)
            }

            Text(body)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(5)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)

            Divider().padding(.vertical, 16)

            HStack {
                if let sourceURL, let url = URL(string: sourceURL) {
                    Button(action: { UIApplication.shared.open(url) }) {
                        Label(source, systemImage: "arrow.up.right.square")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .tint(accent)
                } else {
                    Text(source)
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                Button(action: { UIApplication.shared.open(URL(string: "https://duckduckgo.com/?q=\(queryText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!) }) {
                    Image(systemName: "safari")
                        .font(.system(size: 15))
                }
                .tint(accent)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
    }
}

// MARK: - List

private extension ResultDetailView {
    func listDetail(items: [String], source: String) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: { copy(item) }) {
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(accent.opacity(0.7))
                            .frame(width: 22, alignment: .trailing)
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 11))
                            .foregroundStyle(.quaternary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < items.count - 1 {
                    Divider().padding(.leading, 50).opacity(0.5)
                }
            }

            Divider()

            Button(action: { copy(items.joined(separator: "\n")) }) {
                Label("Copy All", systemImage: "doc.on.doc.fill")
                    .font(.system(size: 13, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
            }
            .tint(accent)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
    }
}

// MARK: - Color

private extension ResultDetailView {
    func colorDetail(_ hex: String) -> some View {
        let swatch = Color(hex: hex) ?? accent
        let rgb = hexToRGB(hex)
        let hsl = rgbToHSL(rgb.r, rgb.g, rgb.b)
        return VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(swatch)
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))

            VStack(spacing: 0) {
                colorRow(label: "HEX", value: "#\(hex.uppercased())")
                Divider().padding(.leading, 52).opacity(0.5)
                colorRow(label: "RGB", value: "rgb(\(rgb.r), \(rgb.g), \(rgb.b))")
                Divider().padding(.leading, 52).opacity(0.5)
                colorRow(label: "HSL", value: "hsl(\(hsl.h)°, \(hsl.s)%, \(hsl.l)%)")
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
        }
    }

    func colorRow(label: String, value: String) -> some View {
        Button(action: { copy(value) }) {
            HStack {
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.tertiary)
                    .frame(width: 36, alignment: .leading)
                Text(value)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 11))
                    .foregroundStyle(.quaternary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    struct RGB { var r: Int; var g: Int; var b: Int }
    struct HSL { var h: Int; var s: Int; var l: Int }

    func hexToRGB(_ hex: String) -> RGB {
        let h = hex.replacingOccurrences(of: "#", with: "")
        guard let v = Int(h, radix: 16) else { return RGB(r: 0, g: 0, b: 0) }
        return RGB(r: (v >> 16) & 0xFF, g: (v >> 8) & 0xFF, b: v & 0xFF)
    }

    func rgbToHSL(_ r: Int, _ g: Int, _ b: Int) -> HSL {
        let rf = Double(r) / 255, gf = Double(g) / 255, bf = Double(b) / 255
        let cmax = max(rf, gf, bf), cmin = min(rf, gf, bf), delta = cmax - cmin
        let l = (cmax + cmin) / 2
        let s = delta == 0 ? 0.0 : delta / (1 - abs(2 * l - 1))
        var h = 0.0
        if delta > 0 {
            if cmax == rf { h = 60 * (((gf - bf) / delta).truncatingRemainder(dividingBy: 6)) }
            else if cmax == gf { h = 60 * ((bf - rf) / delta + 2) }
            else { h = 60 * ((rf - gf) / delta + 4) }
        }
        if h < 0 { h += 360 }
        return HSL(h: Int(h.rounded()), s: Int((s * 100).rounded()), l: Int((l * 100).rounded()))
    }
}

// MARK: - Convert

private extension ResultDetailView {
    func convertDetail(from: String, to: String, fromUnit: String, toUnit: String) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text(from)
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(.secondary)
                        .minimumScaleFactor(0.5)
                    Text(fromUnit)
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }
                Image(systemName: "arrow.right")
                    .font(.system(size: 18))
                    .foregroundStyle(accent.opacity(0.4))
                VStack(spacing: 4) {
                    Text(to)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.primary)
                        .minimumScaleFactor(0.5)
                    Text(toUnit)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(accent)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(28)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
        }
    }
}

// MARK: - Error

private extension ResultDetailView {
    func errorDetail(message: String, searchURL: String?) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.quaternary)
            Text(message)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if let searchURL, let url = URL(string: searchURL) {
                Button("Search on DuckDuckGo") { UIApplication.shared.open(url) }
                    .font(.system(size: 14, weight: .medium))
                    .tint(accent)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(36)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
    }
}

// MARK: - Color extension

private extension Color {
    init?(hex: String) {
        let h = hex.replacingOccurrences(of: "#", with: "")
        guard let v = Int(h, radix: 16) else { return nil }
        self.init(red: Double((v >> 16) & 0xFF) / 255, green: Double((v >> 8) & 0xFF) / 255, blue: Double(v & 0xFF) / 255)
    }
}
