import SwiftUI

struct CountryDetailView: View {
    let country: Country
    @State private var searchText = ""
    @State private var expandedDocs: Set<String> = []

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: []) {
                ForEach(country.docs) { doc in
                    DocSection(doc: doc, searchText: searchText, isExpanded: expandedDocs.contains(doc.id)) {
                        if expandedDocs.contains(doc.id) { expandedDocs.remove(doc.id) }
                        else { expandedDocs.insert(doc.id) }
                    }
                }
            }
            .padding(16)
        }
        .background(Color(hex: "0c1220"))
        .navigationTitle(country.name)
        .searchable(text: $searchText, prompt: "Search within constitution...")
        .onAppear {
            expandedDocs = Set(country.docs.map(\.id))
        }
    }
}

struct DocSection: View {
    let doc: ConstitutionalDoc
    let searchText: String
    let isExpanded: Bool
    let onToggle: () -> Void

    var articles: [Article] {
        if searchText.isEmpty { return doc.articles }
        return doc.articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.text.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(doc.title)
                            .font(.system(.subheadline, design: .serif).weight(.bold))
                            .foregroundColor(Color(hex: "4e9cd7"))
                            .multilineTextAlignment(.leading)
                        Text("\(doc.year) · \(doc.parent)")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "4a6070"))
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "4a6070"))
                }
                .padding(12)
                .background(Color(hex: "111c2e"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article, docTitle: doc.title)) {
                            ArticleRow(article: article)
                        }
                    }
                    if articles.isEmpty {
                        Text("No results").font(.caption).foregroundColor(Color(hex: "4a6070")).padding(.vertical, 8)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}

struct ArticleRow: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(article.ref.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Color(hex: "2472b2"))
                .tracking(1)
            Text(article.title)
                .font(.system(.callout, design: .serif).weight(.bold))
                .foregroundColor(Color(hex: "e8e4da"))
            Text(article.text)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "7a8e9e"))
                .lineLimit(2)
            TagRow(tags: article.tags)
        }
        .padding(10)
        .background(Color(hex: "0c1220"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "1f3050"), lineWidth: 1))
    }
}

struct TagRow: View {
    let tags: [String]
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tags, id: \.self) { tag in
                Text(tag.uppercased())
                    .font(.system(size: 8, weight: .medium))
                    .tracking(0.8)
                    .foregroundColor(tagColor(tag))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(tagColor(tag).opacity(0.1))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(tagColor(tag).opacity(0.4), lineWidth: 0.5))
            }
        }
    }
    func tagColor(_ tag: String) -> Color {
        switch tag {
        case "civil": return Color(hex: "4e9cd7")
        case "political": return Color(hex: "6a9fcf")
        case "economic": return Color(hex: "7aab7a")
        case "social": return Color(hex: "c4956a")
        case "cultural": return Color(hex: "a07bc8")
        default: return Color(hex: "7a8e9e")
        }
    }
}
