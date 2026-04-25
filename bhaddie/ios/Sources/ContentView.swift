import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Radar", systemImage: "dot.radiowaves.left.and.right", value: 0) {
                RadarView()
            }
            Tab("Beacon", systemImage: "bolt.fill", value: 1) {
                BeaconView()
            }
            Tab("Economy", systemImage: "dollarsign.circle", value: 2) {
                EconomyView()
            }
        }
        .tint(Theme.accent)
    }
}

#Preview {
    ContentView()
}
