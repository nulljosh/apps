# Charters iOS

v0.0.1 — Native iOS companion for the Charters web app. SwiftUI, iOS 17+.

## Build

```bash
xcodegen generate
open Charters.xcodeproj
# Simulator: iPhone 17 Pro
```

## Structure

```
Sources/
  ChartersApp.swift             @main entry point
  ColorExtension.swift          shared color helpers
  Models/
    ChartersData.swift          country/article data model
    UserStore.swift             user profile state
    CaseStore.swift             case/comparison tracking
  Views/
    ContentView.swift           root tab container
    CountryListView.swift       list + filter UI
    CountryDetailView.swift     articles for a country
    ArticleDetailView.swift     full article text
    CompareView.swift           side-by-side comparison
    AuthView.swift              sign-in / profile
    ProfileView.swift           user profile
```

## Data

Constitutional data mirrors `apps/charters/index.html` (JS source). 15 countries, 146 articles, 23 documents.

## Deploy

iOS only — not on App Store. TestFlight when ready.
