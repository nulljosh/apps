<img src="icon.png" width="80">

# Bhaddie

![version](https://img.shields.io/badge/version-v0.3.0-blue)

Location-based social + creator economy. Snap Map meets attention arbitrage.

## Features

- **Radar** -- real venues near you from OpenStreetMap, plus user-submitted sightings from Supabase
- **Beacon** -- broadcast your location with privacy tiers (exact pin / fuzzy 500m / district only)
- **Economy** -- token wallet, live activity feed, clout leaderboard, verified badges
- **Auth** -- sign up / sign in, drop pins on the map, submit baddie sightings with vibe + description
- **Geolocation** -- centers on your location, "you are here" marker
- **Vibe legend** -- gym (pink), alt (violet), artsy (cyan), downtown (amber), night owl (green)

## Data Sources

| Source | Type | Auth Required |
|---|---|---|
| **Supabase** | User-submitted sightings (24h TTL) | Yes |
| **Overpass API** | Real OpenStreetMap venues (fallback) | No |
| **Demo data** | Hardcoded profiles (offline fallback) | No |

## Stack

| Platform | Tech |
|---|---|
| **Web** | Vite, MapLibre GL JS, CartoDB tiles, Supabase (auth + DB), Overpass API |
| **iOS** | SwiftUI, MapKit, iOS 18+ |
| **macOS** | SwiftUI, MapKit, macOS 15+ |

## Setup

```bash
cd web
cp .env.example .env.local
# Edit .env.local with your Supabase project URL + anon key
npm install
npm run dev
```

Run `schema.sql` against your Supabase project to create tables + RLS policies.

## Run

```bash
# Web (localhost:5173)
cd web && npm run dev

# Tests (59 tests)
cd web && npm test

# iOS
cd ios && xcodegen generate && open Bhaddie.xcodeproj

# macOS
cd macos && xcodegen generate && open Bhaddie.xcodeproj
```

## Roadmap

**This Weekend**
- [ ] Create Supabase project + run `schema.sql`
- [ ] Wire up auth (sign up / sign in / sign out)
- [ ] User-submitted baddie sightings (pin drop live)
- [ ] Real-time sighting feed via Supabase subscriptions

**Next**
- [ ] Push notifications for proximity alerts
- [ ] Stripe token purchases
- [ ] Baddie Hours scheduling (live broadcast windows)
- [ ] Clout score algorithm v2
- [ ] Deploy to Vercel (bhaddie.heyitsmejosh.com)
- [ ] iOS + macOS Supabase integration

## License

MIT 2026 Joshua Trommel
