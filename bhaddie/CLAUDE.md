# Bhaddie

## What
Location-based social + creator economy app. Users sign up and drop pins to report baddie sightings with vibe tags. Falls back to OpenStreetMap venue data when no user data exists.

## Core Concepts
- **Radar** -- map with user-submitted sightings (Supabase) + venue blips (Overpass API fallback)
- **Beacon** -- opt-in location broadcasting with privacy tiers (exact/fuzzy/district)
- **Economy** -- token wallet, live activity feed, clout leaderboard

## Data
- **Primary**: Supabase -- user accounts (profiles table), sightings (24h TTL, RLS-protected)
- **Fallback**: OpenStreetMap Overpass API -- real venues within 1.2km
- **Offline**: hardcoded demo data
- **Auth**: Supabase Auth (email/password, auto-profile creation via trigger)
- **Geolocation**: browser Geolocation API, Vancouver fallback

## Stack
- **Web**: Vite + vanilla JS modules, MapLibre GL JS, CartoDB tiles, @supabase/supabase-js
- **iOS**: SwiftUI + MapKit, iOS 18+, xcodegen
- **macOS**: SwiftUI + MapKit, macOS 15+, xcodegen, NavigationSplitView sidebar
- **Tests**: Vitest (59 tests -- auth validation, data mapping, Supabase module, edge cases)

## Design
- Dark-first social aesthetic, auto light/dark via prefers-color-scheme + manual toggle
- Primary: #ff2d78 (hot pink), Secondary: #8b5cf6 (violet), Tertiary: #06b6d4 (cyan)
- Dark bg: #0a0a0f, Cards: #16161f, Light bg: #f8f8fc, Cards: #ffffff
- -apple-system font stack
- Spring hover: `transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1)`
- No gradients on interactive elements, no box-shadows

## Setup
```bash
cd web
cp .env.example .env.local   # add VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY
npm install
npm run dev
```

Run `schema.sql` against Supabase to create tables + RLS + triggers.

## Run
```bash
cd web && npm run dev          # localhost:5173
cd web && npm test             # 59 tests
cd ios && xcodegen generate    # iOS
cd macos && xcodegen generate  # macOS
```

## Structure
```
bhaddie/
  web/
    index.html          -- single-file app (CSS + HTML inline, JS module)
    src/supabase.js     -- Supabase client, auth, sighting CRUD
    test/               -- vitest tests (auth, data, supabase)
    package.json        -- vite + vitest + @supabase/supabase-js
    .env.example        -- env var template
    manifest.json       -- PWA manifest
  ios/                  -- SwiftUI iOS app
  macos/                -- SwiftUI macOS app
  schema.sql            -- Supabase database schema + RLS + triggers
  whitepaper.md         -- satirical attention economy thesis
  icon.svg / icon.png
  architecture.svg
```
