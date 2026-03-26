import SwiftUI

@main
struct LifeApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if showSplash {
                    SplashView()
                        .transition(.scale(scale: 1.05).combined(with: .opacity))
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    showSplash = false
                }
            }
        }
    }
}
