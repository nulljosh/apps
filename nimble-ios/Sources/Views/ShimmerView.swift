import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        Rectangle()
            .fill(shimmer)
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }

    private var shimmer: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Color(.systemFill), location: phase - 0.3),
                .init(color: Color(.secondarySystemFill), location: phase),
                .init(color: Color(.systemFill), location: phase + 0.3),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct LoadingSkeletonView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ShimmerView()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 8) {
                ShimmerView().frame(height: 13).clipShape(RoundedRectangle(cornerRadius: 4))
                    .frame(maxWidth: .infinity * 0.45, alignment: .leading)
                ShimmerView().frame(height: 11).clipShape(RoundedRectangle(cornerRadius: 4))
                ShimmerView().frame(height: 11).clipShape(RoundedRectangle(cornerRadius: 4))
                    .opacity(0.7)
            }
            .padding(.top, 2)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
}
