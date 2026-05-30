# Lingo
v1.3.0

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

Categories: `languages`, `programming`, `computers`, `math`, `science`, `skills` (+ `games`).

## Skill tree

Selecting a subject opens a unit/lesson path (`#skillTree`) before the lesson runner. A
lesson unlocks when it is first in the course or the previous lesson is complete; completed
lessons show a crown. Per-lesson completion lives in `lessons_completed` (keyed
`<subjectId>/<lessonId>`) inside `lingo.progress`. Starting a tree lesson plays exactly that
lesson's exercises; the legacy whole-subject path (`startLesson()` with no id) stays as review
mode. Listening exercises speak via on-device `speechSynthesis` using the pack `lang`.

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
