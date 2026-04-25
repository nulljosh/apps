# fuse
v1.0.0

## What
Timepage-style timeline with bomb-timer countdowns. EventKit/iCal integration + custom sources (Tally payday). Cross-platform: web, iOS, macOS, watchOS.

## Run
```bash
# Web
npm install && npm run dev

# iOS
cd ios && xcodegen generate && open Fuse.xcodeproj

# macOS
cd macos && xcodegen generate && open FuseMac.xcodeproj
```

## Key Files
- `src/pages/Timeline.jsx` — main timeline view
- `src/components/CountdownTile.jsx` — ticking countdown display
- `src/data/customSources.js` — payday calc + mock events
- `ios/Services/CalendarService.swift` — EventKit reads
- `ios/Services/CustomSourceService.swift` — Tally payday
- `ios/Views/TimelineView.swift` — iOS timeline
- `macos/Views/MacTimelineView.swift` — macOS split-view timeline

## Rules
- Apple Liquid Glass design (backdrop-filter blur, frosted cards, -apple-system)
- Countdown urgency: blue > 72h, orange 24-72h, red < 24h
- No emojis
- iOS 17+, macOS 14+, Swift 6.0
