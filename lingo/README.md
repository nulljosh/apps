<img src="icon.svg" width="80">

# Lingo

![version](https://img.shields.io/badge/version-v1.3.0-blue)

Interactive learning platform -- languages, programming, computers, math, science, and more.

[lingo.heyitsmejosh.com](https://lingo.heyitsmejosh.com)

## Features

- Data-driven courses: lazy-loaded JSON packs, scales past 100+ courses
- Skill-tree lesson path: units, locked/unlocked nodes, crowns on completed lessons
- Computers track: digital-literacy course (hardware, files, internet, security, AI, command line)
- Exercise types: translation, sentence building, listening, typing, math, multiple choice
- SM-2 spaced repetition with per-card review scheduling
- Audio pronunciation via on-device text-to-speech (per-course language voice)
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
- [x] Skill-tree lesson path (units, crowns)
- [x] Computer/digital-literacy track
- [x] Audio pronunciation (TTS)
- [ ] Live code runner (Pyodide + sandboxed JS)
- [ ] 100+ languages via content generator
- [ ] Accounts + cloud sync + leaderboard (Supabase)

## Changelog

v1.3.0
- Skill-tree lesson path: units, locked/unlocked nodes, per-lesson crowns, per-lesson progress.
- New Computers category + `Computer Basics` digital-literacy course (6 units, real content).
- Deep, unit-structured Spanish and Python courses replace the flat migrated banks.
- Text-to-speech pronunciation on listening exercises (per-course language voice).

v1.2.0
- Course content moved to lazy-loaded JSON packs (`content/`). Removed dead PocketBase scaffolding.

v1.1.0
- Added light theme with auto system preference detection.

## License

MIT 2026 Joshua Trommel
