import SwiftUI
import WebKit

/// Renders post HTML in a transparent WKWebView with system-font styling that
/// adapts to light/dark mode. Cross-platform: UIView on iOS, NSView on macOS.
private func styledDocument(_ body: String) -> String {
    """
    <!doctype html>
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <style>
      :root { color-scheme: light dark; }
      body {
        font: -apple-system-body;
        font-family: -apple-system, system-ui, sans-serif;
        line-height: 1.6;
        margin: 0;
        padding: 4px 2px 40px;
        color: #1c1c1e;
        background: transparent;
        -webkit-text-size-adjust: 100%;
      }
      @media (prefers-color-scheme: dark) { body { color: #e8e4da; } }
      h1, h2, h3 { line-height: 1.25; margin: 1.4em 0 0.4em; }
      h2 { font-size: 1.25em; text-transform: lowercase; }
      p { margin: 0 0 1em; }
      a { color: #0071e3; text-decoration: none; }
      img { max-width: 100%; height: auto; border-radius: 12px; }
      code, pre { font-family: ui-monospace, Menlo, monospace; }
      pre { overflow-x: auto; padding: 12px; background: rgba(127,127,127,0.12); border-radius: 12px; }
    </style>
    </head>
    <body>\(body)</body>
    </html>
    """
}

#if os(iOS)
struct HTMLView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(styledDocument(html), baseURL: FeedStore.siteURL)
    }
}
#elseif os(macOS)
struct HTMLView: NSViewRepresentable {
    let html: String

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(styledDocument(html), baseURL: FeedStore.siteURL)
    }
}
#endif
