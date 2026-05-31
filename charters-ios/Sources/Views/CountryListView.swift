import SwiftUI

struct CountryListView: View {
    @EnvironmentObject var auth: AuthManager
    @Binding var selectedCountry: Country?
    @Binding var showCompare: Bool
    @State private var searchText = ""
    @State private var activeFilter = "all"
    @State private var showProfile = false
    @State private var showAuth = false

    let filters = ["all","civil","political","economic","social","cultural"]

    var filtered: [Country] {
        chartersData.filter { c in
            let matchFilter = activeFilter == "all" || c.allArticles.contains { $0.tags.contains(activeFilter) }
            let matchSearch = searchText.isEmpty || c.name.localizedCaseInsensitiveContains(searchText) ||
                c.allArticles.contains { $0.title.localizedCaseInsensitiveContains(searchText) || $0.text.localizedCaseInsensitiveContains(searchText) }
            return matchFilter && matchSearch
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(filters, id: \.self) { f in
                        Button(f == "all" ? "All" : f.capitalized) {
                            activeFilter = f
                        }
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(activeFilter == f ? Color(hex: "1a5a96") : Color(hex: "111c2e"))
                        .foregroundColor(activeFilter == f ? .white : Color(hex: "7a8e9e"))
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 8)
            }
            Divider().background(Color(hex: "1f3050"))

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filtered) { country in
                        Button {
                            selectedCountry = country
                            showCompare = false
                        } label: {
                            CountryCard(country: country)
                        }
                        .buttonStyle(CardButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollContentBackground(.hidden)
        }
        .searchable(text: $searchText, prompt: "Search rights...")
        .background(Color(hex: "0c1220"))
        .navigationTitle("Charters")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    Button("Compare") {
                        showCompare = true
                        selectedCountry = nil
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "4e9cd7"))
                    Button {
                        if auth.currentUser != nil { showProfile = true }
                        else { showAuth = true }
                    } label: {
                        Image(systemName: auth.currentUser != nil ? "person.fill" : "person")
                            .font(.system(size: 14))
                            .foregroundColor(auth.currentUser != nil ? Color(hex: "4e9cd7") : Color(hex: "7a8e9e"))
                    }
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(selectedCountry: $selectedCountry)
        }
        .sheet(isPresented: $showAuth) {
            AuthView()
        }
    }
}

struct CountryCard: View {
    let country: Country

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(country.name)
                        .font(.system(.title3, design: .serif).weight(.bold))
                        .foregroundColor(Color(hex: "e8e4da"))
                    Text(country.region.uppercased())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(hex: "7a8e9e"))
                        .tracking(1.2)
                }
                Spacer()
                Text("\(country.allArticles.count) articles")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "4e9cd7"))
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color(hex: "4e9cd7").opacity(0.12))
                    .clipShape(Capsule())
            }
            HStack(spacing: 6) {
                ForEach(Array(country.allTags).sorted(), id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(Color(hex: tagColor(tag)))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color(hex: tagColor(tag)).opacity(0.12))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "111c2e"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(hex: "1f3050"), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.35), radius: 12, y: 6)
    }

    func tagColor(_ t: String) -> String {
        switch t {
        case "civil": return "4e9cd7"
        case "political": return "6a9fcf"
        case "economic": return "7aab7a"
        case "social": return "c4956a"
        case "cultural": return "a07bc8"
        default: return "7a8e9e"
        }
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

