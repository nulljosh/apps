# Nimble
v1.0.0

Native macOS app for instant answers. SwiftUI windowed app (menubar mode blocked by Tahoe beta).

## Stack
- SwiftUI, macOS 14+, @Observable
- xcodegen for project generation
- NSExpression + custom function evaluator for math (trig, sqrt, log, powers, pi)
- DuckDuckGo Instant Answer API (free, no key)
- Wikipedia REST API as fallback

## Structure
- `Sources/NimbleApp.swift` -- @main entry, Window scene (MenuBarExtra commented out)
- `Sources/Models/` -- AppState, QueryEngine, Preferences
- `Sources/Views/` -- SearchView, ResultView, SettingsView, ContextMenuView
- `Resources/` -- Assets, entitlements, suggestions.json
- `Tests/` -- 26 tests (QueryEngine + Preferences)
- `docs/` -- GitHub Pages landing at heyitsmejosh.com/nimble/

## Build
```bash
xcodegen generate
xcodebuild -scheme Nimble -destination 'platform=macOS'
```

## Config
Options stored at `~/.nimble-options.json`. Themes: orange (default), red, yellow, green, blue, purple, pink, contrast.

## Known Issues
- MenuBarExtra does not render status item on macOS Tahoe beta (Xcode 26.2 beta). Temporarily using Window scene instead. MenuBarExtra code is commented out in NimbleApp.swift, ready to re-enable.
- Global hotkey (Cmd+Shift+=) requires MenuBarExtra/NSStatusItem, disabled for now.

## Inspired By
Maybulb/Nimble (deprecated 2020, was Electron + Wolfram|Alpha)
