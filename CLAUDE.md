# Apps Monorepo

v3.0.0

Standalone apps and experiments. Each subdirectory is independent with its own build system.

## Apps

### Web
- **dose** -- Health tracker (Vite + React). Live: dose.heyitsmejosh.com. Has ios/ + watchos/.
- **tally** -- BC Self-Serve scraper + benefits guide. Express + Puppeteer + Vercel Blob. PWA. Live: tally.heyitsmejosh.com. Has ios/, macos/, watchos/, widgets-ios/, widgets-macos/.
- **lingo** -- Language learning (vanilla JS PWA)
- **politics** -- Political compass (vanilla JS)
- **nimble-web** -- Instant answers + web search with mind-map (Vite + React). Live: nimble.heyitsmejosh.com. Merged from rabbit.
- **roost** -- BC real estate (Vite + React PWA)
- **usage** -- Usage tracking
- **bhaddie** -- Location-based social + creator economy (web/, ios/, macos/)

### iOS (SwiftUI)
- **browser** / **browser-ios** -- WebKit browser
- **life** / **life-ios** -- Life simulator
- **nimble** / **nimble-ios** -- Instant answers (macOS/iOS)
- **nyc** / **nyc-ios** / **nyc-web** -- Times Square colony sim (SpriteKit / Canvas)
- **lingo-ios** -- Language learning
- **dashboard-ios** -- Dashboard
- **journal-ios** -- Journal companion
- **portfolio-ios** -- Portfolio companion

## Build

```bash
# SwiftUI apps
cd <app-dir> && xcodegen generate && open *.xcodeproj

# Vite apps
cd <app-dir> && npm install && npm run dev

# Vanilla apps
cd <app-dir> && python3 -m http.server 8080
```

Requirements: Xcode 16+, xcodegen, iOS 17+ / macOS 14+.

## Conventions
- Every sub-app has its own README.md, CLAUDE.md, icon.svg, architecture.svg
- SwiftUI apps use project.yml (xcodegen)
- MIT licensed
