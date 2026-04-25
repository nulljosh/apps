import SwiftUI
import WebKit

struct WebViewWrapper: NSViewRepresentable {
    @Bindable var appState: AppState
    let tabID: UUID

    func makeCoordinator() -> Coordinator {
        Coordinator(appState: appState, tabID: tabID)
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = appState.webView(for: tabID)
        context.coordinator.attach(to: webView)

        if webView.url == nil, let tab = appState.tab(for: tabID) {
            webView.load(URLRequest(url: tab.url))
        }

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        context.coordinator.attach(to: nsView)
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKDownloadDelegate {
        private let appState: AppState
        private let tabID: UUID
        private weak var webView: WKWebView?
        private var progressObservation: NSKeyValueObservation?

        init(appState: AppState, tabID: UUID) {
            self.appState = appState
            self.tabID = tabID
        }

        deinit {
            progressObservation?.invalidate()
        }

        func attach(to webView: WKWebView) {
            guard self.webView !== webView else { return }

            progressObservation?.invalidate()
            self.webView = webView
            webView.navigationDelegate = self
            webView.uiDelegate = self
            observeProgress(for: webView)
            pushState(for: webView)
            installContextMenu(on: webView)
        }

        // MARK: - Context Menu

        private func installContextMenu(on webView: WKWebView) {
            // WKWebView handles its own context menus via WKUIDelegate
            // We add custom items in the delegate method below
        }

        // MARK: - KVO

        private func observeProgress(for webView: WKWebView) {
            progressObservation = webView.observe(\.estimatedProgress, options: [.initial, .new]) { [weak self] webView, _ in
                self?.appState.loadingProgress = webView.estimatedProgress
            }
        }

        private func pushState(for webView: WKWebView) {
            appState.updateTabState(
                tabID: tabID,
                url: webView.url,
                title: webView.title,
                isLoading: webView.isLoading,
                canGoBack: webView.canGoBack,
                canGoForward: webView.canGoForward
            )
        }

        private func updateFavicon(_ image: NSImage?) {
            guard let index = appState.tabs.firstIndex(where: { $0.id == tabID }) else { return }
            appState.tabs[index].favicon = image
        }

        // MARK: - Favicon

        private func fetchFavicon(for webView: WKWebView) {
            let faviconScript = """
            (() => {
                const icon = document.querySelector("link[rel~='icon'], link[rel='shortcut icon']");
                if (icon && icon.href) {
                    return icon.href;
                }
                return null;
            })();
            """

            webView.evaluateJavaScript(faviconScript) { [weak self, weak webView] result, _ in
                guard let self, let webView else { return }

                let faviconURL: URL?
                if let iconString = result as? String, let iconURL = URL(string: iconString) {
                    faviconURL = iconURL
                } else if let pageURL = webView.url, let host = pageURL.host {
                    var components = URLComponents()
                    components.scheme = pageURL.scheme ?? "https"
                    components.host = host
                    components.port = pageURL.port
                    components.path = "/favicon.ico"
                    faviconURL = components.url
                } else {
                    faviconURL = nil
                }

                guard let faviconURL else { return }

                let request = URLRequest(url: faviconURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
                URLSession.shared.dataTask(with: request) { data, _, _ in
                    guard let data, let image = NSImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.updateFavicon(image)
                    }
                }.resume()
            }
        }

        // MARK: - Audio Detection

        private func detectAudioState(for webView: WKWebView) {
            let script = """
            (() => {
                const elements = document.querySelectorAll('video, audio');
                let playing = false;
                elements.forEach(el => {
                    if (!el.paused && !el.muted && el.volume > 0) playing = true;
                });
                return playing;
            })();
            """

            webView.evaluateJavaScript(script) { [weak self] result, _ in
                guard let self else { return }
                let isPlaying = result as? Bool ?? false
                if let index = self.appState.tabs.firstIndex(where: { $0.id == self.tabID }) {
                    if self.appState.tabs[index].isPlayingAudio != isPlaying {
                        self.appState.tabs[index].isPlayingAudio = isPlaying
                    }
                }
            }
        }

        // MARK: - Scroll Position

        private func saveScrollPosition(for webView: WKWebView) {
            webView.evaluateJavaScript("window.pageYOffset") { [weak self] result, _ in
                guard let self, let offset = result as? Double else { return }
                if let index = self.appState.tabs.firstIndex(where: { $0.id == self.tabID }) {
                    self.appState.tabs[index].scrollPosition = CGFloat(offset)
                }
                TabManager.shared.saveScrollPosition(CGFloat(offset), for: self.tabID)
            }
        }

        private func restoreScrollPosition(for webView: WKWebView) {
            let position = TabManager.shared.scrollPosition(for: tabID)
            guard position > 0 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                webView.evaluateJavaScript("window.scrollTo(0, \(position));")
            }
        }

        // MARK: - Error Page

        private func errorHTML(for error: Error, originalURL: URL?) -> String {
            let message = escapeHTML(error.localizedDescription)
            let retryURL = originalURL?.absoluteString ?? "about:blank"
            let escapedRetryURL = retryURL
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "'", with: "\\'")

            return """
            <!doctype html>
            <html lang="en">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Page Load Failed</title>
                <style>
                    :root {
                        color-scheme: light dark;
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    }
                    body {
                        margin: 0;
                        min-height: 100vh;
                        display: grid;
                        place-items: center;
                        background: linear-gradient(180deg, rgba(244,244,245,1) 0%, rgba(228,228,231,1) 100%);
                    }
                    @media (prefers-color-scheme: dark) {
                        body { background: linear-gradient(180deg, #1c1c1e 0%, #000 100%); }
                        .card { background: rgba(44,44,46,0.92); color: #f5f5f7; }
                        .card p { color: #a1a1a6; }
                    }
                    .card {
                        width: min(560px, calc(100vw - 48px));
                        padding: 32px;
                        border-radius: 18px;
                        background: rgba(255,255,255,0.92);
                        box-shadow: 0 18px 60px rgba(0,0,0,0.12);
                        color: #111827;
                    }
                    h1 { margin: 0 0 12px; font-size: 28px; }
                    p { margin: 0 0 20px; line-height: 1.5; color: #374151; }
                    button {
                        border: 0; border-radius: 10px; padding: 10px 16px;
                        background: #007AFF; color: white; font: inherit; cursor: pointer;
                    }
                    button:hover { background: #0056CC; }
                </style>
            </head>
            <body>
                <main class="card">
                    <h1>Unable to Open Page</h1>
                    <p>\(message)</p>
                    <button onclick="window.location.href='\(escapedRetryURL)'">Retry</button>
                </main>
            </body>
            </html>
            """
        }

        private func escapeHTML(_ string: String) -> String {
            string
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
                .replacingOccurrences(of: "\"", with: "&quot;")
                .replacingOccurrences(of: "'", with: "&#39;")
        }

        // MARK: - Downloads

        private func shouldDownload(response: WKNavigationResponse) -> Bool {
            guard let httpResponse = response.response as? HTTPURLResponse else {
                return !response.canShowMIMEType
            }

            let disposition = httpResponse.value(forHTTPHeaderField: "Content-Disposition")?.lowercased() ?? ""
            if disposition.contains("attachment") {
                return true
            }

            guard let mimeType = response.response.mimeType?.lowercased() else {
                return !response.canShowMIMEType
            }

            if mimeType.hasPrefix("text/") || mimeType.hasPrefix("image/") || mimeType.hasPrefix("audio/") || mimeType.hasPrefix("video/") {
                return false
            }

            let supportedApplicationTypes: Set<String> = [
                "application/pdf", "application/json", "application/javascript",
                "application/x-javascript", "application/xml", "application/xhtml+xml", "application/wasm"
            ]

            if supportedApplicationTypes.contains(mimeType) {
                return false
            }

            return true
        }

        private func downloadDestination(for response: URLResponse) -> URL {
            let downloadsDir = appState.preferences.resolvedDownloadsDirectory
            let suggestedFilename = response.suggestedFilename ?? response.url?.lastPathComponent ?? UUID().uuidString
            let fileURL = downloadsDir.appendingPathComponent(suggestedFilename)
            var candidateURL = fileURL
            var counter = 1

            while FileManager.default.fileExists(atPath: candidateURL.path) {
                let baseName = fileURL.deletingPathExtension().lastPathComponent
                let pathExtension = fileURL.pathExtension
                let candidateName = pathExtension.isEmpty
                    ? "\(baseName)-\(counter)"
                    : "\(baseName)-\(counter).\(pathExtension)"
                candidateURL = downloadsDir.appendingPathComponent(candidateName)
                counter += 1
            }

            return candidateURL
        }

        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            pushState(for: webView)
            PrivacyManager.shared.resetTrackerCount(for: tabID)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            pushState(for: webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            pushState(for: webView)
            fetchFavicon(for: webView)
            detectAudioState(for: webView)
            restoreScrollPosition(for: webView)

            if let url = webView.url {
                appState.addHistoryEntry(url: url, title: webView.title)
            }

            // Apply zoom for the host
            if let host = webView.url?.host {
                let zoom = appState.preferences.zoomLevel(for: host)
                if abs(webView.pageZoom - zoom) > 0.01 {
                    webView.pageZoom = zoom
                }
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            pushState(for: webView)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let originalURL = (error as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL
                ?? webView.url
                ?? appState.tab(for: tabID)?.url

            pushState(for: webView)
            webView.loadHTMLString(errorHTML(for: error, originalURL: originalURL), baseURL: originalURL?.deletingLastPathComponent())
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Handle target=_blank
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                appState.addTab(url: url)
                decisionHandler(.cancel)
                return
            }

            // HTTPS upgrade
            if appState.preferences.httpsOnlyMode,
               let url = navigationAction.request.url,
               let upgraded = url.httpsUpgraded {
                decisionHandler(.cancel)
                webView.load(URLRequest(url: upgraded))
                return
            }

            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if shouldDownload(response: navigationResponse) {
                decisionHandler(.download)
                return
            }

            decisionHandler(.allow)
        }

        // MARK: - WKUIDelegate

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard navigationAction.targetFrame == nil, let url = navigationAction.request.url else {
                return nil
            }

            appState.addTab(url: url)
            return nil
        }

        // MARK: - WKDownloadDelegate

        func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self
        }

        func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
            download.delegate = self
        }

        func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
            completionHandler(downloadDestination(for: response))
        }

        func downloadDidFinish(_ download: WKDownload) {
        }

        func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        }
    }
}
