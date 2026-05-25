import SwiftUI

struct MacEquationListView: View {
    @Bindable var store: EquationStore
    var onExport: () -> Void

    private let bg = Color(hex: "111110")
    private let surface = Color.white.opacity(0.04)
    private let borderColor = Color.white.opacity(0.10)
    private let textColor = Color(hex: "f2ede8")
    private let mutedColor = Color.white.opacity(0.35)

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("EQUATIONS")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.0)
                    .foregroundColor(mutedColor)
                Spacer()
                Button(action: onExport) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 12))
                        .foregroundColor(mutedColor)
                }
                .buttonStyle(.plain)
                .help("Export PNG")

                Button(action: { store.add() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "0071e3"))
                }
                .buttonStyle(.plain)
                .help("Add Equation (Cmd+Shift+N)")
                .keyboardShortcut("n", modifiers: [.command, .shift])
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider().background(borderColor)

            List {
                ForEach($store.equations) { $eq in
                    MacEquationRowView(equation: $eq, showRemove: store.equations.count > 1) {
                        store.remove(id: eq.id)
                    } onChange: {
                        store.save()
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .onDelete { offsets in
                    store.remove(at: offsets)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .background(bg)
    }
}

struct MacEquationRowView: View {
    @Binding var equation: Equation
    let showRemove: Bool
    let onRemove: () -> Void
    let onChange: () -> Void

    private let textColor = Color(hex: "f2ede8")

    var body: some View {
        HStack(spacing: 8) {
            Button {
                equation.enabled.toggle()
                onChange()
            } label: {
                Circle()
                    .fill(Color(hex: equation.color.hasPrefix("#") ? String(equation.color.dropFirst()) : equation.color))
                    .frame(width: 10, height: 10)
                    .opacity(equation.enabled ? 1 : 0.3)
            }
            .buttonStyle(.plain)

            TextField("e.g. sin(x)", text: $equation.expression)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(textColor)
                .textFieldStyle(.plain)
                .onChange(of: equation.expression) { onChange() }

            if showRemove {
                Button(action: onRemove) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.white.opacity(0.20))
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}
