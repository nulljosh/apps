# Lingo
v1.2.0

## Rules

- No build process -- pure HTML/CSS/JS, static deploy
- Dark Editorial design (Fraunces + DM Sans), auto light/dark mode
- Touch-friendly: minimum 44px tap targets
- All transitions under 300ms, 60fps animations
- Static + localStorage. Supabase (accounts/sync/leaderboard) is roadmap, not active.

## Content architecture

Courses are data, not code. The runtime never hardcodes lessons.

- `content/catalog.json` -- course metadata only (id, name, category, icon, level, packPath). Loaded once at startup.
- `content/courses/<id>.json` -- one pack per course (units -> lessons -> exercises). Lazy-fetched on subject select, cached in-memory + service worker.
- `content/schema.json` -- the pack contract. Shared source of truth for web, native (lingo-ios/macos), and the generator.

A course appears in the catalog only if it has a real pack (no empty shells, no fake data).

## Scripts

- `node scripts/migrate-to-packs.mjs` -- regenerate catalog + packs from the legacy `js/lingo-data.js` source (one-shot cutover helper).
- `node scripts/gen-pack.mjs <id>` -- author a new real course pack (roadmap).

## Run

```bash
python3 -m http.server 8080   # serve; fetch() needs http, not file://
```

## Deploy

```bash
npx vercel --prod
```
