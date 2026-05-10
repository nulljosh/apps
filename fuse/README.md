<img src="icon.svg" width="80">

# fuse

![version](https://img.shields.io/badge/version-v1.2.0-blue)

Timeline app with bomb-timer countdowns. iCal + Google Calendar integration + custom sources.

## Platforms

- **Web** — React 19 + Vite. Live: fuse.heyitsmejosh.com
- **iOS** — SwiftUI 6.0, iOS 17+, EventKit
- **macOS** — SwiftUI 6.0, macOS 14+
- **watchOS** — Next event + payday countdown

## Features

- Timeline scroll with heat-strip density view
- Live ticking countdowns (days:hours:mins:secs)
- Urgency color shift: blue → orange → red at 72h/24h
- Fuse progress bar depleting as event approaches
- Google Calendar + any iCal/ICS feed via secret URL (AES-GCM encrypted at rest)
- EventKit integration on iOS/macOS (all native calendars)
- Tally payday source (BC Income Assistance, last Wednesday of month)
- Geist font

## Calendar Setup (Web)

Tap Calendars in the nav bar. Paste a Google Calendar ICS URL:
Google Calendar → Settings → [Calendar] → "Secret address in iCal format"

## License

MIT 2026 Joshua Trommel
