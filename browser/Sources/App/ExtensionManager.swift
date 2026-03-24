import Foundation
import WebKit

struct BrowserExtensionManifest: Codable {
    let name: String
    let version: String
    let description: String?
    let contentScripts: [ContentScriptEntry]?
    let background: BackgroundEntry?

    enum CodingKeys: String, CodingKey {
        case name, version, description
        case contentScripts = "content_scripts"
        case background
    }
}

struct ContentScriptEntry: Codable {
    let matches: [String]
    let js: [String]?
    let css: [String]?
    let runAt: String?

    enum CodingKeys: String, CodingKey {
        case matches, js, css
        case runAt = "run_at"
    }
}

struct BackgroundEntry: Codable {
    let scripts: [String]?
}

struct BrowserExtension: Identifiable {
    let id: String
    let manifest: BrowserExtensionManifest
    let directoryURL: URL
    var isEnabled: Bool

    var name: String { manifest.name }
    var version: String { manifest.version }
}

@MainActor
final class ExtensionManager {
    static let shared = ExtensionManager()

    private(set) var extensions: [BrowserExtension] = []
    private var backgroundWebViews: [String: WKWebView] = [:]

    private var extensionsDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Browser/Extensions", isDirectory: true)
    }

    private init() {}

    func loadExtensions() {
        let fm = FileManager.default
        try? fm.createDirectory(at: extensionsDirectory, withIntermediateDirectories: true)

        guard let contents = try? fm.contentsOfDirectory(
            at: extensionsDirectory,
            includingPropertiesForKeys: [.isDirectoryKey]
        ) else { return }

        extensions.removeAll()

        for dirURL in contents {
            var isDir: ObjCBool = false
            guard fm.fileExists(atPath: dirURL.path, isDirectory: &isDir), isDir.boolValue else { continue }

            let manifestURL = dirURL.appendingPathComponent("manifest.json")
            guard let data = try? Data(contentsOf: manifestURL),
                  let manifest = try? JSONDecoder().decode(BrowserExtensionManifest.self, from: data) else { continue }

            let ext = BrowserExtension(
                id: dirURL.lastPathComponent,
                manifest: manifest,
                directoryURL: dirURL,
                isEnabled: true
            )
            extensions.append(ext)
        }
    }

    func contentScripts(for url: URL) -> [WKUserScript] {
        var scripts: [WKUserScript] = []

        for ext in extensions where ext.isEnabled {
            guard let contentScripts = ext.manifest.contentScripts else { continue }

            for entry in contentScripts {
                guard matchesPattern(url: url, patterns: entry.matches) else { continue }

                let injectionTime: WKUserScriptInjectionTime
                switch entry.runAt {
                case "document_start": injectionTime = .atDocumentStart
                default: injectionTime = .atDocumentEnd
                }

                if let jsFiles = entry.js {
                    for jsFile in jsFiles {
                        let fileURL = ext.directoryURL.appendingPathComponent(jsFile)
                        if let source = try? String(contentsOf: fileURL, encoding: .utf8) {
                            scripts.append(WKUserScript(
                                source: source,
                                injectionTime: injectionTime,
                                forMainFrameOnly: true
                            ))
                        }
                    }
                }
            }
        }

        return scripts
    }

    func startBackgroundScripts() {
        for ext in extensions where ext.isEnabled {
            guard let background = ext.manifest.background, let bgScripts = background.scripts else { continue }

            let config = WKWebViewConfiguration()
            let webView = WKWebView(frame: .zero, configuration: config)

            var combinedSource = ""
            for script in bgScripts {
                let fileURL = ext.directoryURL.appendingPathComponent(script)
                if let source = try? String(contentsOf: fileURL, encoding: .utf8) {
                    combinedSource += source + "\n"
                }
            }

            if !combinedSource.isEmpty {
                webView.evaluateJavaScript(combinedSource)
            }

            backgroundWebViews[ext.id] = webView
        }
    }

    func stopBackgroundScripts() {
        backgroundWebViews.removeAll()
    }

    func toggleExtension(id: String) {
        guard let index = extensions.firstIndex(where: { $0.id == id }) else { return }
        extensions[index].isEnabled.toggle()

        if !extensions[index].isEnabled {
            backgroundWebViews.removeValue(forKey: id)
        }
    }

    private func matchesPattern(url: URL, patterns: [String]) -> Bool {
        let urlString = url.absoluteString
        for pattern in patterns {
            if pattern == "<all_urls>" { return true }
            if pattern == "*://*/*" { return true }

            let regexPattern = pattern
                .replacingOccurrences(of: ".", with: "\\.")
                .replacingOccurrences(of: "*", with: ".*")

            if urlString.range(of: regexPattern, options: .regularExpression) != nil {
                return true
            }
        }
        return false
    }
}
