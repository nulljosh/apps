import SwiftUI

@main
struct LifeApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(onReady: dismissSplash)

                if showSplash {
                    SplashView()
                        .transition(.scale(scale: 1.05).combined(with: .opacity))
                }
            }
        }
    }

    private func dismissSplash() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            showSplash = false
        }
    }
}
