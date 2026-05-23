import Foundation
import WebKit

@MainActor
final class CompassSession: ObservableObject {
    @Published var isLoading = false
    @Published var pageTitle = ""

    let processPool = WKProcessPool()

    var webViewConfig: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.processPool = processPool
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        return config
    }
}
