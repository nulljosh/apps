# Compass iOS

Native iOS wrapper for compasscard.ca (TransLink BC).

## Structure

- `Sources/CompassApp.swift` — entry point
- `Sources/ContentView.swift` — TabView with CompassTab enum (home/reload/trips/account)
- `Sources/Views/CompassWebView.swift` — UIViewRepresentable WKWebView with KVO progress/canGoBack
- `Sources/Views/TabWebView.swift` — NavigationStack + toolbar (refresh button, progress bar)
- `Sources/Models/CompassSession.swift` — shared WKProcessPool + WKWebViewConfiguration

## Key Decisions

- Single shared `WKWebsiteDataStore.default()` across all tabs keeps auth cookies persistent
- Each tab gets its own WKWebView instance (not shared) — avoids navigation state conflicts
- `refreshID = UUID()` pattern triggers view recreation for pull-to-refresh

## URLs

- Home: https://www.compasscard.ca/
- Reload: https://www.compasscard.ca/LoadValue
- Trips: https://www.compasscard.ca/CardUse
- Account: https://www.compasscard.ca/MyAccount

## Build

```sh
xcodegen generate
open CompassIOS.xcodeproj
```
