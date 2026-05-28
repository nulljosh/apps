import SwiftUI

struct PostDetailView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.largeTitle.bold())
                if !post.displayDate.isEmpty {
                    Text(post.displayDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)

            HTMLView(html: post.contentHTML)
                .padding(.horizontal, 16)
        }
        .background(.ultraThinMaterial)
        .toolbar {
            if let url = post.url {
                Link(destination: url) {
                    Image(systemName: "safari")
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
