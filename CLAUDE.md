# Apps Monorepo

v3.0.0

Standalone apps and experiments. Each subdirectory is independent with its own build system.

## Apps

### Web
- **cadence** -- Code progress tracker (GitHub GraphQL API). Live: cadence.heyitsmejosh.com.
- **dose** -- Health/supplement tracker (Vite + React). Live: dose.heyitsmejosh.com.
- **epiphany** -- Finance/intelligence dashboard. Vite + React. Live: epiphany.heyitsmejosh.com. Subdirs: ios/, macos/, watchos/, widgets-ios/, widgets-macos/, bank/, dashboard/, finn/, cloudflare/, tradingview/.
- **grapher** -- Desmos-style graphing calculator. Live: grapher.heyitsmejosh.com.
- **lingo** -- Language learning (vanilla JS PWA)
- **nimble-web** -- Instant answers + web search with mind-map (Vite + React). Live: nimble.heyitsmejosh.com.
- **beep-web** -- Beep PWA (iframe wrapper for compasscard.ca). Single-file HTML. Deploy: `cd apps/beep-web && npx vercel --prod`.
- **nyc-web** -- Times Square colony sim (Canvas). Live: nyc.heyitsmejosh.com. Separate Vercel project — deploy with `cd apps/nyc-web && npx vercel --prod`.
- **parallax** -- Head-tracked 3D parallax via webcam + MediaPipe. Static HTML.
- **roost** -- Zillow clone for BC real estate. Vite + React PWA + Leaflet map, price pill markers, filters, Supabase auth. Live: roost.heyitsmejosh.com. Next: real BC listings scraper, agent profiles, price history, saved searches.
- **spark** -- Idea forum with voting, comments, JWT auth. Expanding to: law integration (entity formation, terms gen), IP/trademark filing workflow. Live: spark.heyitsmejosh.com.
- **school** -- Grade 12 academic tracker (UVic BSc CS admission). Live: school.heyitsmejosh.com.
- **tally** -- BC Self-Serve scraper + benefits guide. Express + Puppeteer + Vercel Blob. PWA. Live: tally.heyitsmejosh.com.
- **wiretext** -- Unicode wireframe design tool (Vite + React). Live: wiretext.heyitsmejosh.com.

### Cross-platform
- **brief/** -- Charter litigation tool (Trommel v. AG Canada). Web: nulljosh.github.io/brief/ (heyitsmejosh.com/brief). Subdirs: ios/, macos/.

### iOS (SwiftUI)
- **bhaddie** -- Location-based social + creator economy
- **brief-ios** -- Native SwiftUI litigation planning app (Trommel v. AG Canada). Synced with heyitsmejosh.com/brief/.
- **life** / **life-ios** -- Therapy document for Amanda. 32 sections, dual timeline, SVG charts. Private.
- **lingo-ios** -- Language learning
- **nimble** / **nimble-ios** -- Instant answers (macOS/iOS). MenuBarExtra blocked (Tahoe SDK bug).
- **nyc** / **nyc-ios** -- Times Square colony sim (SpriteKit)
- **portfolio-ios** -- Portfolio companion
- **beep** -- Native SwiftUI iOS app for TransLink Compass card. Native login (hidden WKWebView + JS injection), Face ID, balance/trips dashboard, reload sheet.
- **wiretext-ios** -- Unicode wireframe design tool (iOS)

### macOS (SwiftUI)
- **lingo-macos** -- Language learning
- **nimble** -- MenuBarExtra (blocked, macOS Tahoe SDK bug)
- **wiretext-macos** -- Unicode wireframe design tool (macOS)

## Build

```bash
# SwiftUI apps
cd <app-dir> && xcodegen generate && open *.xcodeproj
# Default simulator: iPhone 17 Pro

# Vite apps
cd <app-dir> && npm install && npm run dev

# Vanilla/static apps
cd <app-dir> && python3 -m http.server 8080
```

Requirements: Xcode 26.2 beta, xcodegen, iOS 17+ / macOS 14+.

## Conventions
- Every sub-app has its own README.md, CLAUDE.md, icon.svg, architecture.svg
- SwiftUI apps use project.yml (xcodegen)
- MIT licensed 2026 Joshua Trommel
- Apply all changes to ALL platforms automatically (web + iOS + macOS + watchOS)
