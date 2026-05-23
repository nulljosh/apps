import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: CompassSession

    var body: some View {
        Group {
            switch session.authState {
            case .unknown, .loggingIn:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
            case .loggedOut:
                LoginView()
            case .loggedIn:
                MainTabView()
            }
        }
        .task {
            await session.checkAuthState()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "creditcard.fill") }
            TripsView()
                .tabItem { Label("Trips", systemImage: "tram.fill") }
            AccountView()
                .tabItem { Label("Account", systemImage: "person.fill") }
        }
        .tint(Color(red: 0, green: 0.44, blue: 0.89))
    }
}
