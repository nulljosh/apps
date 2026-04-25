import SwiftUI

@main
struct NimbleApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        Window("Nimble", id: "main") {
            SearchView()
                .environment(appState)
                .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
                .onAppear { configureWindow() }
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 680, height: 56)
    }

    private func configureWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for window in NSApp.windows {
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.isMovableByWindowBackground = true
                window.titlebarAppearsTransparent = true
                window.titleVisibility = .hidden
                window.backgroundColor = .clear
                window.isOpaque = false
                window.hasShadow = true
                // Shrink to just the search bar height
                var frame = window.frame
                frame.size.height = 56
                frame.origin.y += (window.frame.height - 56)
                window.setFrame(frame, display: true, animate: false)
            }
        }
    }
}
