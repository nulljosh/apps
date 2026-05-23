import SwiftUI

struct TabWebView: View {
    let url: URL
    let title: String

    @EnvironmentObject var session: CompassSession
    @StateObject private var actions = WebViewActions()
    @State private var progress: Double = 0
    @State private var canGoBack = false
    @State private var isOffline = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                CompassWebView(
                    url: url,
                    progress: $progress,
                    canGoBack: $canGoBack,
                    isOffline: $isOffline,
                    actions: actions
                )
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

                if isOffline {
                    OfflineView {
                        isOffline = false
                        actions.reload?()
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if canGoBack {
                        Button { actions.goBack?() } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { actions.reload?() } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isOffline)
                }
            }
        }
    }
}

private struct OfflineView: View {
    let onRetry: () -> Void

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 56))
                    .foregroundStyle(.secondary)
                Text("No Connection")
                    .font(.title2.weight(.semibold))
                Text("Check your network and try again.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry", action: onRetry)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0, green: 0.44, blue: 0.89))
            }
            .padding(40)
        }
    }
}
