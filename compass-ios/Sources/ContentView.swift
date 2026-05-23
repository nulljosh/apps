import SwiftUI

enum CompassTab: Int, CaseIterable {
    case home, reload, trips, account

    var title: String {
        switch self {
        case .home: "Home"
        case .reload: "Reload"
        case .trips: "Trips"
        case .account: "Account"
        }
    }

    var icon: String {
        switch self {
        case .home: "creditcard.fill"
        case .reload: "plus.circle.fill"
        case .trips: "tram.fill"
        case .account: "person.fill"
        }
    }

    var url: URL {
        let base = "https://www.compasscard.ca"
        switch self {
        case .home: return URL(string: base)!
        case .reload: return URL(string: "\(base)/LoadValue")!
        case .trips: return URL(string: "\(base)/CardUse")!
        case .account: return URL(string: "\(base)/MyAccount")!
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = CompassTab.home

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(CompassTab.allCases, id: \.self) { tab in
                TabWebView(url: tab.url, title: tab.title)
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
        .accentColor(Color(red: 0, green: 0.44, blue: 0.89))
    }
}
