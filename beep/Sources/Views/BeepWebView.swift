import SwiftUI
import WebKit

struct BeepWebView: UIViewRepresentable {
    let url: URL
    @Binding var progress: Double
    @Binding var canGoBack: Bool
    @Binding var isOffline: Bool
    var actions: WebViewActions

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: "canGoBack", options: .new, context: nil)

        actions.goBack = { webView.goBack() }
        actions.reload = { webView.reload() }

        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if context.coordinator.lastURL != url {
            context.coordinator.lastURL = url
            webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        }
        context.coordinator.parent = self
    }

    static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.removeObserver(coordinator, forKeyPath: "estimatedProgress")
        webView.removeObserver(coordinator, forKeyPath: "canGoBack")
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: BeepWebView
        var lastURL: URL?

        init(_ parent: BeepWebView) {
            self.parent = parent
            self.lastURL = parent.url
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            guard let webView = object as? WKWebView else { return }
            if keyPath == "estimatedProgress" {
                Task { @MainActor in self.parent.progress = webView.estimatedProgress }
            } else if keyPath == "canGoBack" {
                Task { @MainActor in self.parent.canGoBack = webView.canGoBack }
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            Task { @MainActor in self.parent.isOffline = false }
        }

        func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) {}

        func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
            let e = error as NSError
            let isNetwork = e.domain == NSURLErrorDomain && [
                NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost,
                NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost
            ].contains(e.code)
            Task { @MainActor in self.parent.isOffline = isNetwork }
        }
    }
}
