# Usage

## Rules

- No build process -- pure HTML/CSS/JS, static deploy
- Dark Editorial design (Fraunces + DM Sans, deep dark bg)
- Touch-friendly: minimum 44px tap targets
- All transitions under 300ms, 60fps animations
- localStorage persistence, JSON export/import
- PWA via service worker + manifest.json
- No API keys or external auth required
- Manual entry only (no scraping provider dashboards)

## Run

```bash
open index.html
# or
python3 -m http.server 8080
```

## Structure

```
index.html          # Single-page app shell
css/usage.css       # Dark Editorial styles
js/store.js         # localStorage persistence + data model
js/stats.js         # Aggregation engine (daily/weekly/monthly)
js/charts.js        # Canvas-based chart rendering
js/app.js           # Router, UI controller, event binding
manifest.json       # PWA manifest
sw.js               # Service worker (cache-first)
```

## Data Model

Entries stored as JSON array in localStorage key `usage_entries`:
```json
{
  "id": "uuid",
  "provider": "claude|chatgpt|custom",
  "date": "2026-03-26",
  "conversations": 5,
  "tokensEstimate": 25000,
  "costEstimate": 0,
  "model": "opus-4",
  "notes": ""
}
```

Settings in localStorage key `usage_settings`.
