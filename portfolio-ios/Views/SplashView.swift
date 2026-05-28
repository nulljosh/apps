import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.primary)
                Text("Portfolio")
                    .font(.title2.bold())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .ignoresSafeArea()
    }
}
