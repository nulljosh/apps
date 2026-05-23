import SwiftUI

struct TabWebView: View {
    let url: URL
    let title: String

    @EnvironmentObject var session: CompassSession
    @State private var progress: Double = 0
    @State private var canGoBack = false
    @State private var refreshID = UUID()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                CompassWebView(url: url, progress: $progress, canGoBack: $canGoBack)
                    .id(refreshID)
                    .ignoresSafeArea(edges: .bottom)

                if progress > 0 && progress < 1 {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: geo.size.width * progress, height: 3)
                            .animation(.linear(duration: 0.15), value: progress)
                    }
                    .frame(height: 3)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if canGoBack {
                        Button {
                            // back handled by allowsBackForwardNavigationGestures
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .disabled(!canGoBack)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        refreshID = UUID()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}
