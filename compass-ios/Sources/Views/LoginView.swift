import SwiftUI
import WebKit

struct LoginView: View {
    @EnvironmentObject var session: CompassSession

    var body: some View {
        LoginWebView { url in
            let lower = url.lowercased()
            if !lower.contains("signin") && !lower.contains("register") && !lower.isEmpty {
                Task { await session.handleLoginSuccess() }
            }
        }
        .ignoresSafeArea()
    }
}

struct LoginWebView: UIViewRepresentable {
    var onNavigate: (String) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: "https://www.compasscard.ca/SignIn")!))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: LoginWebView
        var didLogin = false

        init(_ parent: LoginWebView) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            guard !didLogin else { return }
            let url = webView.url?.absoluteString ?? ""
            parent.onNavigate(url)
        }
    }
}
