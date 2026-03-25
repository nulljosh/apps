import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Joshua Adam Trommel")
                    .font(.system(size: 32, weight: .bold))
                    .tracking(-0.5)
                    .multilineTextAlignment(.center)

                Rectangle()
                    .fill(.green)
                    .frame(width: 40, height: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            }
        }
    }
}
