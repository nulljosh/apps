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
                        .transition(.opacity)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.easeOut(duration: 0.3)) {
                    showSplash = false
                }
            }
        }
    }
}
