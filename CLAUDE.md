# Apps Monorepo

Standalone apps and experiments. Each subdirectory is independent with its own build system.

## Structure

Two types of sub-apps:

### SwiftUI Apps (macOS/iOS)
- browser, browser-ios, life, life-ios, nimble, nyc, nyc-ios

Build:
```bash
cd <app-dir>
xcodegen generate   # generates .xcodeproj from project.yml
open *.xcodeproj    # or xcodebuild -scheme <Name> build
```

Requirements: Xcode 16+, xcodegen (`/opt/homebrew/bin/xcodegen`), iOS 17+ / macOS 14+.

Test:
```bash
xcodebuild test -scheme <Name> -destination 'platform=macOS'
```

### Web Apps
- dose (Vite + React), lingo (vanilla JS PWA), politics (vanilla JS), rabbit, roost (Vite + React PWA)

Build (Vite apps):
```bash
cd <app-dir>
npm install
npm run dev       # dev server
npm run build     # production build to dist/
```

Build (vanilla apps):
```bash
cd <app-dir>
# Open index.html directly or:
python3 -m http.server 8080
```

Test (Vite apps):
```bash
npm test
```

## Dose

Full health tracker with web + iOS + watchOS. Has its own Vercel deployment at dose.heyitsmejosh.com.
- Web: `dose/` -- Vite + React, Dark Editorial design
- iOS: `dose/ios/` -- SwiftUI, HealthKit, interaction checker
- watchOS: `dose/ios/watchos/` -- companion app
- API: `dose/api/sync.js` -- Vercel serverless sync endpoint

## Conventions
- Every sub-app has its own README.md, CLAUDE.md, icon.svg, architecture.svg
- SwiftUI apps use project.yml (xcodegen) instead of checked-in .xcodeproj
- MIT licensed
