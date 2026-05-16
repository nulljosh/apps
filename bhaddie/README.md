<img src="icon.png" width="80">

# Pulse

![version](https://img.shields.io/badge/version-v0.4.0-blue)

Real-time scene radar + creator economy. Drop vibe reports at locations, broadcast your presence, earn tokens.

## Features

- **Radar** -- live scene blips from real OSM venues + user drops via Supabase. Realtime updates via Supabase subscriptions.
- **Beacon** -- opt-in location broadcasting with privacy tiers (exact pin / fuzzy 500m / district only). Persisted per user.
- **Economy** -- token wallet, live activity feed, real clout leaderboard from Supabase, verified badges
- **Auth** -- sign up / sign in, drop scenes on the map with vibe + description, earn tokens per drop
- **Geolocation** -- centers on your location, "you are here" marker, broadcaster markers for nearby live users
- **Vibe legend** -- gym (pink), alt (violet), artsy (cyan), downtown (amber), night owl (green)

## Data Sources

| Source | Type | Auth Required |
|---|---|---|
| **Supabase** | User drops (24h TTL), profiles, leaderboard, beacon status | Yes |
| **Overpass API** | Real OpenStreetMap venues (fallback) | No |
| **Demo data** | Hardcoded scene blips (offline fallback) | No |

## Stack

| Platform | Tech |
|---|---|
| **Web** | Vite, MapLibre GL JS, CartoDB tiles, Supabase (auth + DB + realtime), Overpass API |
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

Run `schema.sql` against your Supabase project to create tables, RLS policies, and RPCs.

## Run

```bash
# Web (localhost:5173)
cd web && npm run dev

# Tests
cd web && npm test

# iOS
cd ios && xcodegen generate && open Pulse.xcodeproj

# macOS
cd macos && xcodegen generate && open Pulse.xcodeproj
```

## Roadmap

- [ ] Push notifications for proximity alerts
- [ ] Stripe token purchases
- [ ] Live Hours scheduling (broadcast window boost)
- [ ] Clout score algorithm v2
- [ ] Deploy to Vercel (pulse.heyitsmejosh.com)
- [ ] iOS + macOS Supabase integration

## License

MIT 2026 Joshua Trommel
