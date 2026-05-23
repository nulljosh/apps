import SwiftUI

struct ReloadSheetView: View {
    @EnvironmentObject var session: BeepSession
    @Environment(\.dismiss) private var dismiss
    @StateObject private var actions = WebViewActions()
    @State private var progress: Double = 0
    @State private var canGoBack = false
    @State private var isOffline = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                BeepWebView(
                    url: URL(string: "https://www.compasscard.ca/LoadValue")!,
                    progress: $progress,
                    canGoBack: $canGoBack,
                    isOffline: $isOffline,
                    actions: actions
                )

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
            .navigationTitle("Reload Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if canGoBack {
                        Button { actions.goBack?() } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Task { await session.loadDashboard() }
                        dismiss()
                    }
                }
            }
        }
    }
}
