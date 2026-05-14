# brief/ios

Native iOS app for *Trommel v. AG Canada* litigation planning. SwiftUI port of heyitsmejosh.com/brief.

## Stack: SwiftUI, iOS 17+, Swift 6, xcodegen

## Key files
- `Sources/Models/CaseData.swift` — all hardcoded data (grounds, witnesses, journal seed, lawyers, checklist, call script, email template)
- `Sources/Models/Store.swift` — @Observable UserDefaults wrapper (journal, checklist, theme)
- `Sources/Views/CaseTabView.swift` — Case tab (facts, witnesses, grounds accordion, journal)
- `Sources/Views/MoneyTabView.swift` — Money tab (scenarios, damage stack, Ward framework)
- `Sources/Views/ActionsTabView.swift` — Actions tab (lawyers, timeline, checklist, scripts, risks)

## Build
```
cd apps/brief/ios && xcodegen generate && open Brief.xcodeproj
```
Bundle: `com.nulljosh.brief` | Team: `QMM486NPYC` | iOS 17+

## Platforms
- Web: `nulljosh.github.io/brief/` — heyitsmejosh.com/brief
- iOS: `apps/brief/ios/`
- macOS: `apps/brief/macos/`

## Data sync
When updating case facts, lawyers, or grounds — edit `CaseData.swift` AND `apps/brief/macos/Sources/Models/CaseData.swift` AND the web app at `nulljosh.github.io/brief/`. Keep all three in sync.

## Paul Kent
Correct firm as of 2026-05-13: Kane Shannon & Weiler (KSW), Surrey BC. Email: pgkent@kswlawyers.ca. Phone: 604-591-7321. NOT Lindsay Kenney.
