# brief/macos

Native macOS app for *Trommel v. AG Canada* litigation planning. SwiftUI port of heyitsmejosh.com/brief.

## Stack: SwiftUI, macOS 14+, Swift 6, xcodegen

## Key files
- `Sources/Models/CaseData.swift` — all hardcoded data (grounds, witnesses, lawyers, checklist, scripts)
- `Sources/Models/Store.swift` — @MainActor @Observable Store; Supabase auth + DB sync (journal, checklist, lawyer statuses, theme)
- `Sources/Models/SupabaseClient.swift` — sbClient singleton (spark project, emitLocalSessionAsInitialSession: true)
- `Sources/Views/SignInView.swift` — magic link email form (OTP flow)
- `Sources/ContentView.swift` — NavigationSplitView (sidebar: Case / Money / Actions)
- `Sources/Views/CaseTabView.swift` — Case panel (facts, witnesses, grounds accordion, journal)
- `Sources/Views/MoneyTabView.swift` — Money panel (scenarios, damage stack, Ward framework)
- `Sources/Views/ActionsTabView.swift` — Actions panel (lawyers, timeline, checklist, scripts)

## Build
```
cd apps/brief/macos && xcodegen generate && open Brief.xcodeproj
```
Bundle: `com.nulljosh.brief-macos` | Team: `QMM486NPYC` | macOS 14+

## Data sync
When updating case facts, lawyers, or grounds — edit `CaseData.swift` AND sync with:
- `apps/brief/ios/Sources/Models/CaseData.swift`
- `nulljosh.github.io/brief/script.js`
