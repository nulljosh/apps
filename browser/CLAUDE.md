# Browser

## Rules

- WebKit only, no Chromium
- macOS 14+, SwiftUI chrome, WKWebView for content
- @Observable (not ObservableObject) for state
- JSON file persistence in ~/Library/Application Support/Browser/
- Sandbox-friendly with network + camera/mic/location entitlements

## Run

```sh
xcodegen generate
xcodebuild -scheme Browser -destination 'platform=macOS' build
```
