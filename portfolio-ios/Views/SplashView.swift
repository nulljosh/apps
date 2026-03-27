import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.primary)
                Text("Portfolio")
                    .font(.title2.bold())
            }
        }
    }
}
