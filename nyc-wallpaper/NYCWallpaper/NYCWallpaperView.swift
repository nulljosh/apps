import ScreenSaver
import WebKit

class NYCWallpaperView: ScreenSaverView {
    private var webView: WKWebView?

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let wv = WKWebView(frame: bounds, configuration: config)
        wv.autoresizingMask = [.width, .height]
        wv.setValue(false, forKey: "drawsBackground")
        addSubview(wv)
        webView = wv

        // Load the NYC game -- tries local deploy first, falls back to live site
        if let url = URL(string: "https://nyc.heyitsmejosh.com") {
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            wv.load(request)
        }

        // Auto-enable wallpaper mode after page loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak wv] in
            wv?.evaluateJavaScript("""
                if (window._gameState) {
                    window._gameState.wallpaperMode = true;
                    window._gameState.autoplay = true;
                }
            """)
        }
    }

    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }

    override func animateOneFrame() {
        // WebKit handles its own rendering
    }
}
