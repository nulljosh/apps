import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    let docTitle: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.ref.uppercased())
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "2472b2"))
                    .tracking(1.2)

                Text(article.title)
                    .font(.system(size: 22, design: .serif).weight(.bold))
                    .foregroundColor(Color(hex: "e8e4da"))

                Text(docTitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "4a6070"))
                    .italic()

                Divider().background(Color(hex: "1f3050"))

                Text(article.text)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "c8c4ba"))
                    .lineSpacing(6)

                TagRow(tags: article.tags)

                Button {
                    UIPasteboard.general.string = article.text
                } label: {
                    Label("Copy text", systemImage: "doc.on.doc")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "4e9cd7"))
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color(hex: "4e9cd7").opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            .padding(20)
        }
        .background(Color(hex: "0c1220"))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
