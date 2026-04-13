import SwiftUI

struct SplashView: View {
    @State private var appeared = false
    @State private var spinnerVisible = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Joshua Adam Trommel")
                    .font(.system(size: 32, weight: .bold))
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)
                    .scaleEffect(appeared ? 1.0 : 0.9)
                    .opacity(appeared ? 1.0 : 0)

                Rectangle()
                    .fill(.green)
                    .frame(width: appeared ? 40 : 0, height: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 2))

                Text("v3.0.0")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .opacity(appeared ? 1.0 : 0)

                ProgressView()
                    .tint(.green)
                    .scaleEffect(0.75)
                    .opacity(spinnerVisible ? 1.0 : 0)
                    .padding(.top, 8)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeIn(duration: 0.3)) {
                    spinnerVisible = true
                }
            }
        }
    }
}
