import SwiftUI

struct BiometricLockView: View {
    @Environment(Store.self) private var store

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 8) {
                Text("BRIEF")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .tracking(4)
                    .foregroundStyle(.secondary)
                Text("private")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.tertiary)
            }
            Image(systemName: "faceid")
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(.primary)
            Button {
                Task { await store.authenticateWithBiometrics() }
            } label: {
                Text("Unlock")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 160, height: 44)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task { await store.authenticateWithBiometrics() }
        }
    }
}
