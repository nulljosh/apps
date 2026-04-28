# Apps Monorepo

v3.0.0

Standalone apps and experiments. Each subdirectory is independent with its own build system.

## Apps

### Web
- **cadence** -- Code progress tracker (GitHub GraphQL API). Live: cadence.heyitsmejosh.com.
- **claude-usage** -- Claude Code usage tracker (session/weekly/extra limits).
- **dose** -- Health/supplement tracker (Vite + React). Live: dose.heyitsmejosh.com.
- **epiphany** -- Finance/intelligence dashboard. Vite + React. Live: epiphany.heyitsmejosh.com. Subdirs: ios/, macos/, watchos/, widgets-ios/, widgets-macos/, bank/, dashboard/, finn/, cloudflare/, tradingview/.
- **fuse** -- Timepage-style timeline with bomb-timer countdowns. iCal + custom sources. Live: fuse.heyitsmejosh.com.
- **lingo** -- Language learning (vanilla JS PWA)
- **nimble-web** -- Instant answers + web search with mind-map (Vite + React). Live: nimble.heyitsmejosh.com.
- **nyc-web** -- Times Square colony sim (Canvas). Live: nyc.heyitsmejosh.com. Separate Vercel project — deploy with `cd apps/nyc-web && npx vercel --prod`.
- **roost** -- BC real estate listings (Vite + React PWA). Live: roost.heyitsmejosh.com. localStorage auth only.
- **spark** -- Idea-sharing platform with voting. Supabase. Live: spark.heyitsmejosh.com.
- **tally** -- BC Self-Serve scraper + benefits guide. Express + Puppeteer + Vercel Blob. PWA. Live: tally.heyitsmejosh.com.
- **wiretext** -- Unicode wireframe design tool (Vite + React). Live: wiretext.heyitsmejosh.com.

### iOS (SwiftUI)
- **bhaddie** -- Location-based social + creator economy
- **claude-usage-ios** -- Claude Code usage tracker (iOS)
- **life** / **life-ios** -- Life tracker
- **lingo-ios** -- Language learning
- **nimble** / **nimble-ios** -- Instant answers (macOS/iOS). MenuBarExtra blocked (Tahoe SDK bug).
- **nyc** / **nyc-ios** -- Times Square colony sim (SpriteKit)
- **portfolio-ios** -- Portfolio companion
- **school** / **school/ios** -- Grade 12 + UVic BSc CS tracker
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
