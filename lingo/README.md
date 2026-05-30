<img src="icon.svg" width="80">

# Lingo

![version](https://img.shields.io/badge/version-v1.2.0-blue)

Interactive learning platform -- languages, programming, computers, math, science, and more.

[lingo.heyitsmejosh.com](https://lingo.heyitsmejosh.com)

## Features

- Data-driven courses: lazy-loaded JSON packs, scales past 100+ courses
- Exercise types: translation, sentence building, listening, typing, math, multiple choice
- SM-2 spaced repetition with per-card review scheduling
- XP, daily streaks, lives, trophies
- Speech recognition for spoken answers
- Offline-capable PWA (service worker caches catalog + visited packs)
- Dark/light mode with system preference detection

## Architecture

Courses are content, not code. See `content/` (catalog + per-course packs) and `CLAUDE.md`.

## Run

```bash
python3 -m http.server 8080
```

## Deploy

```bash
npx vercel --prod
```

## Roadmap

- [x] Spaced repetition algorithm
- [x] Offline mode (service worker)
- [ ] Skill-tree lesson path (units, crowns)
- [ ] Computer/digital-literacy track
- [ ] Live code runner (Pyodide + sandboxed JS)
- [ ] 100+ languages via content generator
- [ ] Audio pronunciation (TTS)
- [ ] Accounts + cloud sync + leaderboard (Supabase)

## Changelog

v1.2.0
- Course content moved to lazy-loaded JSON packs (`content/`). Removed dead PocketBase scaffolding.

v1.1.0
- Added light theme with auto system preference detection.

## License

MIT 2026 Joshua Trommel
