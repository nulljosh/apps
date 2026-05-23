# Politics
Version: v1.0.0 -- complete.

## Rules
- No emojis.
- Single-file political compass test; all HTML/CSS/JS in `index.html`.
- No build tools or dependencies.
- `P[]` is the question bank (6 pages, 62 total).
- `S[]` is the scoring matrix; each entry is `[axis, direction]` where axis is `'e'` (economic) or `'s'` (social) and direction is `1` or `-1`.
- `ans[]` is the user answers array (62 slots, null = unanswered).
- Scoring normalizes each axis by its question count (`et/(ec*2)*10`).
- `render()` builds the current page of questions.
- `calc()` scores all answers and calls `drawCompass()`.
- `drawCompass(econ, social)` renders the SVG grid with an animated dot.
- `shareImage()` creates a canvas-based PNG from the SVG.
- `save()` / restore persist `ans` and `pg` in localStorage.

## Run
```bash
# No build tools or dependencies
open ~/Documents/Code/politics/index.html
git push origin main
```

## Key Files
- `index.html`: Single-file app containing all HTML/CSS/JS, question bank, scoring, rendering, compass drawing, share image generation, and persistence.
