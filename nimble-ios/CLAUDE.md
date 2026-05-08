# Nimble iOS
v1.2.0

iOS instant-answers app. SwiftUI, iOS 17+, xcodegen.

## Stack
- SwiftUI @Observable, iOS 17+
- xcodegen — `project.yml` → `NimbleIOS.xcodeproj`
- API: `nimble.heyitsmejosh.com/api/instant` + `/api/search` (DuckDuckGo + Wikipedia)
- NSExpression for offline math; SFSafariViewController for in-app browsing

## Structure
- `Sources/NimbleApp.swift` — @main entry
- `Sources/Models/AppState.swift` — state, history, theme, debounced search
- `Sources/Models/QueryEngine.swift` — math eval, DDG/Wikipedia queries
- `Sources/Models/Preferences.swift` — UserDefaults persistence
- `Sources/Views/SearchView.swift` — main search + history + shimmer + web results
- `Sources/Views/ResultView.swift` — compact result cards (no background, dividers only)
- `Sources/Views/ResultDetailView.swift` — full detail per result type
- `Sources/Views/SafariView.swift` — SFSafariViewController wrapper
- `Sources/Views/ShimmerView.swift` — loading skeleton
- `Sources/Views/SettingsView.swift` — theme picker + preferences

## Build
```bash
xcodegen generate
xcodebuild -scheme NimbleIOS -destination 'id=<simulator-uuid>' build
```

## Known Issues
- `NSExpression` cannot handle incomplete expressions — guarded with trailing-char check before eval
- Shared icon: `../nimble/icon.svg` (200x200 SVG); AppIcon.png generated via Python/Pillow at 1024x1024
