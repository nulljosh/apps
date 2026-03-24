# Rabbit
v2.2.0

## Rules
- Cascading search order: SearXNG (3 instances) -> DuckDuckGo Lite -> Brave Search
- 5s timeout per engine, auto-skip on 429/CAPTCHA
- CenterSearchNode is a React Flow node, not an overlay -- fitView maxZoom capped at 1
- Radial layout: 8 results per ring, 300px start radius + 220px per ring
- Domain dedup: max 2 results per domain
- Path traversal protection on /api/file/:fileId
- Local mode dormant -- backend code exists but frontend local search is commented out
- No emojis

## Run
```bash
npm install && npm run dev    # Vite dev server on :5173
npm run build                 # Production build
: # No test command documented
```

## Key Files
- `src/main.jsx` Vite entry point and app bootstrap.
- `src/App.jsx` Top-level layout and state wiring for the search UI.
- `src/components/CenterSearchNode.jsx` Center React Flow node for the query.
- `src/components/MindMap.jsx` Radial mind-map layout and edge rendering.
- `src/components/SearchBar.jsx` Search input control and submission handling.
