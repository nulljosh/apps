import SwiftUI

struct EquationListView: View {
    @Bindable var store: EquationStore
    var onExport: () -> Void

    private let bg = Color(hex: "0d0c0b")
    private let surface = Color.white.opacity(0.05)
    private let borderColor = Color.white.opacity(0.10)
    private let textColor = Color(hex: "f2ede8")
    private let mutedColor = Color.white.opacity(0.35)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("EQUATIONS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.0)
                    .foregroundColor(mutedColor)
                Spacer()
                Button(action: onExport) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundColor(mutedColor)
                }
                Button(action: { store.add() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "0071e3"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().background(borderColor)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach($store.equations) { $eq in
                        EquationRowView(equation: $eq, showRemove: store.equations.count > 1) {
                            store.remove(id: eq.id)
                        } onChange: {
                            store.save()
                        }
                        if eq.id != store.equations.last?.id {
                            Divider().background(borderColor).padding(.leading, 16)
                        }
                    }
                }
            }
        }
        .background(surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}

struct EquationRowView: View {
    @Binding var equation: Equation
    let showRemove: Bool
    let onRemove: () -> Void
    let onChange: () -> Void

    @State private var showColorPicker = false

    private let textColor = Color(hex: "f2ede8")

    var body: some View {
        HStack(spacing: 10) {
            // Color dot + enable toggle combined
            Button {
                equation.enabled.toggle()
                onChange()
            } label: {
                Circle()
                    .fill(Color(hex: equation.color.hasPrefix("#") ? String(equation.color.dropFirst()) : equation.color))
                    .frame(width: 12, height: 12)
                    .opacity(equation.enabled ? 1 : 0.3)
            }
            .buttonStyle(.plain)

            TextField("e.g. sin(x)", text: $equation.expression)
                .font(.system(size: 15, design: .monospaced))
                .foregroundColor(textColor)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .onChange(of: equation.expression) { onChange() }

            if showRemove {
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.white.opacity(0.25))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
