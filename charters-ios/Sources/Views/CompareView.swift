import SwiftUI

struct CompareView: View {
    @State private var leftId: String = ""
    @State private var rightId: String = ""
    @State private var filter = "all"

    let filters = ["all","civil","political","economic","social","cultural"]
    var leftCountry: Country? { chartersData.first { $0.id == leftId } }
    var rightCountry: Country? { chartersData.first { $0.id == rightId } }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Picker("Country A", selection: $leftId) {
                    Text("Country A").tag("")
                    ForEach(chartersData) { c in Text(c.name).tag(c.id) }
                }
                .pickerStyle(.menu)
                .tint(Color(hex: "4e9cd7"))
                .frame(maxWidth: .infinity)
                .background(Color(hex: "111c2e"))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text("vs").font(.system(size: 11)).foregroundColor(Color(hex: "4a6070"))

                Picker("Country B", selection: $rightId) {
                    Text("Country B").tag("")
                    ForEach(chartersData) { c in Text(c.name).tag(c.id) }
                }
                .pickerStyle(.menu)
                .tint(Color(hex: "4e9cd7"))
                .frame(maxWidth: .infinity)
                .background(Color(hex: "111c2e"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 16).padding(.vertical, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(filters, id: \.self) { f in
                        Button(f == "all" ? "All" : f.capitalized) { filter = f }
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 12).padding(.vertical, 5)
                            .background(filter == f ? Color(hex: "1a5a96") : Color(hex: "111c2e"))
                            .foregroundColor(filter == f ? .white : Color(hex: "7a8e9e"))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 6)
            }
            Divider().background(Color(hex: "1f3050"))

            if leftId.isEmpty && rightId.isEmpty {
                Spacer()
                Text("Select two countries to compare their rights side by side")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "4a6070"))
                    .multilineTextAlignment(.center)
                    .padding(40)
                Spacer()
            } else {
                GeometryReader { geo in
                    HStack(alignment: .top, spacing: 0) {
                        CompareColumn(country: leftCountry, filter: filter, width: geo.size.width / 2)
                        Divider().background(Color(hex: "1f3050"))
                        CompareColumn(country: rightCountry, filter: filter, width: geo.size.width / 2)
                    }
                }
            }
        }
        .background(Color(hex: "0c1220"))
        .navigationTitle("Compare")
    }
}

struct CompareColumn: View {
    let country: Country?
    let filter: String
    let width: CGFloat

    var articles: [Article] {
        guard let c = country else { return [] }
        return c.allArticles.filter { filter == "all" || $0.tags.contains(filter) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if let c = country {
                    Text(c.name)
                        .font(.system(size: 16, design: .serif).weight(.bold))
                        .foregroundColor(Color(hex: "e8e4da"))
                        .padding(.bottom, 4)
                    ForEach(articles) { a in ArticleRow(article: a) }
                    if articles.isEmpty {
                        Text("No articles match this filter")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "4a6070"))
                    }
                } else {
                    Text("Select a country")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "4a6070"))
                }
            }
            .padding(12)
        }
        .frame(width: width)
    }
}
