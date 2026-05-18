# brief/macos

Native macOS app for *Trommel v. AG Canada* and *Trommel v. Trommel* litigation planning. SwiftUI port of heyitsmejosh.com/brief.

## Stack: SwiftUI, macOS 14+, Swift 6, xcodegen

## Key files
- `Sources/Models/CaseData.swift` — CASE-0001 data (grounds, witnesses, lawyers, checklist, scripts)
- `Sources/Models/FamilyCaseData.swift` — CASE-0002 data (Trommel v. Trommel family tort case)
- `Sources/Models/Store.swift` — @MainActor @Observable Store; Supabase auth + DB sync; `activeCase` for case switching
- `Sources/Models/SupabaseClient.swift` — sbClient singleton (spark project, emitLocalSessionAsInitialSession: true)
- `Sources/Views/SignInView.swift` — magic link email form (OTP flow)
- `Sources/ContentView.swift` — NavigationSplitView (sidebar: Case / Money / Actions); case picker in toolbar
- `Sources/Views/CaseTabView.swift` — Case panel — branches on activeCase
- `Sources/Views/MoneyTabView.swift` — Money panel — branches on activeCase
- `Sources/Views/ActionsTabView.swift` — Actions panel — branches on activeCase

## Build
```
cd apps/brief/macos && xcodegen generate && open Brief.xcodeproj
```
Bundle: `com.nulljosh.brief-macos` | Team: `QMM486NPYC` | macOS 14+

## Data sync
When updating case facts, lawyers, or grounds — edit `CaseData.swift` AND sync with:
- `apps/brief/ios/Sources/Models/CaseData.swift`
- `nulljosh.github.io/brief/script.js`
