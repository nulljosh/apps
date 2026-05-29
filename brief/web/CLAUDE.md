# brief/web

Vanilla JS PWA for *Trommel v. AG Canada* litigation planning. Live at heyitsmejosh.com/brief (nulljosh.github.io/brief/).

## Stack: HTML + CSS + vanilla JS, no framework, Supabase JS CDN

## Key files
- `index.html` — full SPA shell (auth overlay, tweaks panel, three tabs: Case / Money / Actions)
- `script.js` — all logic: Supabase auth, data render, DB sync, tweaks
- `style.css` — dark/light themes, red/amber/ink accents, mobile-first
- `CaseData.json` — NOT used by web (data is hardcoded in script.js); canonical source is per-platform

## Auth
- Email + password, two-step flow (`jatrommel@gmail.com` only — hard-checked before advancing to password step)
- Supabase project: `spark` (shared with spark app) — `tjsxsqlxjmanwvmywwvw.supabase.co`
- Anon key is in `script.js` (public, RLS enforces user_id isolation)
- First login: set password via Supabase dashboard > Auth > Users > jatrommel@gmail.com > Send password reset

## Supabase tables
- `brief_journal` — `{ user_id, date, text }`
- `brief_checklist` — `{ user_id, item_index, completed }`
- `brief_lawyer_status` — `{ user_id, lawyer_id, status }`

## Deploy
GitHub Pages (legacy mode). Push to `nulljosh.github.io/brief/`:
```
cd ~/Documents/Code/nulljosh.github.io && git add -A && git commit -m "..." && git push
```

## Cache busting
`?v=N` on `style.css` and `script.js` links in `index.html`, AND `CACHE = 'brief-vN'` in `sw.js`
(keep both equal). Bump on every CSS/JS change AND when copying to the live deploy folder.
Current: `?v=16` / `brief-v16`

## Deep links
- `?pin=7743` — skips the Supabase auth overlay (read-only view; parents' iMac bookmark).
- `?case=rcmp|family` — selects the active case on load.

## Resilience
Supabase is a CDN dependency. `script.js` guards client creation in a try/catch and the DB
loaders early-return when `_sb` is null, so a CDN failure degrades to a read-only render
instead of a blank page (the `?pin=7743` view still works).

## Data sync rule
When updating case facts, lawyers, or grounds — edit `script.js` AND:
- `apps/brief/ios/Sources/Models/CaseData.swift`
- `apps/brief/macos/Sources/Models/CaseData.swift`

## Platforms
- Web: `apps/brief/web/` → heyitsmejosh.com/brief
- iOS: `apps/brief/ios/`
- macOS: `apps/brief/macos/`

## Paul Kent
Firm: Kane Shannon & Weiler (KSW), Surrey BC. Email: pgkent@kswlawyers.ca. Phone: 604-591-7321.
