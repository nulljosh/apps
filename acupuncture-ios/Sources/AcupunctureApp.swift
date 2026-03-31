import SwiftUI

@main
struct AcupunctureApp: App {
    @State private var store = SessionStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(store)

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.4), value: showSplash)
            .task {
                try? await Task.sleep(for: .seconds(0.8))
                showSplash = false
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ReflexologyTab()
                .tabItem { Label("Reflexology", systemImage: "hand.raised.fingers.spread") }
            MeridianListView()
                .tabItem { Label("Points", systemImage: "target") }
            SymptomFinderView()
                .tabItem { Label("Symptoms", systemImage: "cross.circle") }
            SessionHistoryView()
                .tabItem { Label("History", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90") }
        }
        .tint(Color(red: 0.141, green: 0.447, blue: 0.698))
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.047, green: 0.071, blue: 0.125)
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Image(systemName: "hand.raised.fingers.spread")
                    .font(.system(size: 48, weight: .thin))
                    .foregroundStyle(Color(red: 0.306, green: 0.612, blue: 0.843))
                Text("Acupuncture")
                    .font(.system(.title, design: .serif))
                    .fontWeight(.bold)
                Text("& Reflexology")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
