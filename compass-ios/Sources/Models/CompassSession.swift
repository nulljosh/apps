import Foundation
import WebKit

@MainActor
final class CompassSession: ObservableObject {
    @Published var isLoading = false
    @Published var pageTitle = ""

    var webViewConfig: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        return config
    }
}
