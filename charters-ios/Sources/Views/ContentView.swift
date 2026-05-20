import SwiftUI

struct ContentView: View {
    @State private var selectedCountry: Country?
    @State private var showCompare = false

    var body: some View {
        NavigationSplitView {
            CountryListView(selectedCountry: $selectedCountry, showCompare: $showCompare)
        } detail: {
            if showCompare {
                CompareView()
            } else if let country = selectedCountry {
                CountryDetailView(country: country)
            } else {
                Text("Select a country")
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.secondary)
            }
        }
        .preferredColorScheme(.dark)
    }
}
