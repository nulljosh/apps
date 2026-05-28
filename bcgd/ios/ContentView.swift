import SwiftUI

struct ContentView: View {
    @AppStorage("bcgd_pin") private var storedPin = ""
    @State private var authenticated = false

    var body: some View {
        Group {
            if storedPin.isEmpty || authenticated {
                MainTabView()
            } else {
                PinGate(storedPin: storedPin) { authenticated = true }
            }
        }
        .preferredColorScheme(.dark)
        .task { await NotificationService.requestPermission() }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardTab().tabItem { Label("Dashboard", systemImage: "gauge.badge.plus") }
            InventoryTab().tabItem { Label("Inventory", systemImage: "shippingbox") }
            JobsTab().tabItem { Label("Jobs", systemImage: "wrench.and.screwdriver") }
            SettingsTab().tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(Color(hex: "0071e3"))
    }
}
