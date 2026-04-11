# wiretext web

v1.0.0 — Unicode wireframe tool. Vite + React 19. Dark Editorial design.

## Run

```bash
npm install && npm run dev   # dev server on :5173
npm run build                # production build
```

## Key Files

- `src/lib/presets.js` — 23 component templates (Button through Skeleton)
- `src/lib/engine.js` — grid state, stampComponent, undo/redo, pxToCell
- `src/App.jsx` — root reducer (SELECT_PRESET, PLACE_COMPONENT, UNDO, REDO, CLEAR)
- `src/components/Canvas.jsx` — HTML canvas, monospace char grid, hover preview, click-to-place
- `src/components/Toolbar.jsx` — component palette grouped by category
- `src/components/Inspector.jsx` — cursor coords, preset preview, history counts

## Design

Dark Editorial: `#0c1a12` bg, `#3d9e6a` green, `#d4a843` amber, `#e8e4da` cream, Fraunces serif + DM Sans body.

## Architecture

- `state.grid: string[][]` — 100x50 2D char array
- `stampComponent(grid, template, col, row)` — immutable stamp
- `gridToText(grid)` — joins for export/copy
- Canvas renders via `<canvas>` 2D context (not DOM/pre)
- Undo stack: 50 steps max, stored as grid snapshots

## Notes

- No backend, no external deps beyond React
- Keyboard shortcuts: Ctrl+Z undo, Ctrl+Y redo (canvas must be focused)
- Export writes `wireframe.txt` via Blob URL
