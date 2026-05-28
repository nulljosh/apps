import SwiftUI

struct PinGate: View {
    let storedPin: String
    let onAuthenticated: () -> Void
    @State private var entered = ""
    @State private var shake = false

    var body: some View {
        VStack(spacing: 32) {
            Text("Best Choice Garage Doors").font(.headline).foregroundStyle(.secondary)
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(i < entered.count ? Color(hex: "0071e3") : Color.white.opacity(0.15))
                        .frame(width: 14, height: 14)
                }
            }
            .animation(.spring(duration: 0.3, bounce: 0.4), value: entered.count)
            .offset(x: shake ? -8 : 0)
            PinKeypad(pin: $entered, maxLength: 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onChange(of: entered) { _, val in
            guard val.count == 4 else { return }
            if val == storedPin {
                onAuthenticated()
            } else {
                withAnimation(.spring(duration: 0.05, bounce: 0.9).repeatCount(4)) { shake = true }
                Task {
                    try? await Task.sleep(for: .milliseconds(400))
                    shake = false; entered = ""
                }
            }
        }
    }
}

struct PinKeypad: View {
    @Binding var pin: String
    var maxLength = 4
    private let keys = ["1","2","3","4","5","6","7","8","9","","0","⌫"]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
            ForEach(keys, id: \.self) { key in
                if key.isEmpty {
                    Color.clear.frame(height: 56)
                } else {
                    Button {
                        if key == "⌫" { if !pin.isEmpty { pin.removeLast() } }
                        else if pin.count < maxLength { pin.append(key) }
                    } label: {
                        Text(key).font(.title2.weight(.medium))
                            .frame(maxWidth: .infinity).frame(height: 56)
                            .background(.ultraThinMaterial).clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 40)
    }
}
