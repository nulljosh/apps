import SwiftUI
import WebKit

struct CompassWebView: UIViewRepresentable {
    let url: URL
    @EnvironmentObject var session: CompassSession
    @Binding var progress: Double
    @Binding var canGoBack: Bool
    @Binding var isOffline: Bool
    var actions: WebViewActions

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: session.webViewConfig)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)

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
        webView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.canGoBack))
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CompassWebView
        var lastURL: URL?

        init(_ parent: CompassWebView) {
            self.parent = parent
            self.lastURL = parent.url
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            guard let webView = object as? WKWebView else { return }
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                Task { @MainActor in self.parent.progress = webView.estimatedProgress }
            } else if keyPath == #keyPath(WKWebView.canGoBack) {
                Task { @MainActor in self.parent.canGoBack = webView.canGoBack }
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            Task { @MainActor in
                self.parent.session.isLoading = true
                self.parent.isOffline = false
            }
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            Task { @MainActor in
                self.parent.session.isLoading = false
                self.parent.session.pageTitle = webView.title ?? ""
            }
        }

        func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError error: Error) {
            Task { @MainActor in self.parent.session.isLoading = false }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
            let nsErr = error as NSError
            let isNetworkError = nsErr.domain == NSURLErrorDomain && [
                NSURLErrorNotConnectedToInternet,
                NSURLErrorNetworkConnectionLost,
                NSURLErrorTimedOut,
                NSURLErrorCannotFindHost,
                NSURLErrorCannotConnectToHost
            ].contains(nsErr.code)
            Task { @MainActor in
                self.parent.session.isLoading = false
                self.parent.isOffline = isNetworkError
            }
        }
    }
}
