<img src="icon.svg" width="80">

# Beep

![version](https://img.shields.io/badge/version-v1.2.0-blue)

Native iOS app for the TransLink Compass Card. Headless WKWebView handles auth and data extraction; all UI is SwiftUI.

## Features

- Face ID / Touch ID auto-login on relaunch — no login screen flash
- Balance card with tappable AutoLoad status → in-app settings sheet
- Native reload amount picker ($10 / $20 / $50 / $100 / custom) before payment webview
- Trips tab with SPA-aware polling (waits up to 5s for DOM render)
- Pull-to-refresh on dashboard
- Recent trips preview on home tab

## Build

```sh
xcodegen generate
open Beep.xcodeproj
```

## Architecture

See [architecture.svg](architecture.svg)

## Roadmap

- [ ] Write XCTest suite — unit tests for `CompassCard` model, balance parsing, trip parsing, reload flow
- [ ] Create Apple Shortcut / Shortcuts workflow that triggers Claude to reload the app (run `claude` CLI, pass reload intent)
- [ ] UI snapshot tests for dashboard and reload sheet

## License

MIT 2026, Joshua Trommel
