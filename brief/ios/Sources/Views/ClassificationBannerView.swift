import SwiftUI

struct ClassificationBannerView: View {
    @Environment(Store.self) private var store

    var body: some View {
        HStack(spacing: 10) {
            label("VOL. I", red: false)
            dot
            label("PRE-LITIGATION", red: true)
            dot
            label("NOT LEGAL ADVICE", red: false)
            dot
            label(store.activeCase.rawValue, red: false)
            dot
            label("BC, CAN", red: false)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 26)
        .background(.ultraThickMaterial)
        .overlay(alignment: .bottom) {
            Color.secondary.opacity(0.15).frame(height: 0.5)
        }
    }

    private var dot: some View {
        Text("·")
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(.tertiary)
    }

    private func label(_ s: String, red: Bool) -> some View {
        Text(s)
            .font(.system(size: 9, weight: .semibold, design: .monospaced))
            .tracking(2)
            .foregroundStyle(red ? Color.briefDanger : Color.secondary)
    }
}
