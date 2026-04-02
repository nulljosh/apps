# Nimble Web
v1.0.0

Web search engine with radial mind-map visualization. Merged from Rabbit project.

## Stack
- Vite + React 19 + React Flow (@xyflow/react)
- Vercel serverless function for search API
- Cascading search: SearXNG (3 instances) -> DuckDuckGo Lite -> Brave
- Client-side math evaluation (ported from native Nimble)
- Geist font, Animate.css, dark/light theme

## Structure
- `src/main.jsx` -- Vite entry point
- `src/App.jsx` -- React Flow mind-map layout, state management
- `src/App.css` -- All styles, CSS variables, dark mode
- `src/components/CenterSearchNode.jsx` -- Search input node (center of mind-map)
- `src/components/ResultNode.jsx` -- Search result node (radial layout)
- `src/lib/mathEngine.js` -- Offline math evaluation (sqrt, sin, cos, tan, log, ln, abs, pow, pi, e)
- `src/lib/suggestions.js` -- Rotating placeholder suggestions
- `api/search.js` -- Vercel serverless function, cascading multi-engine search

## Run
```bash
npm install && npm run dev    # Vite dev server on :5173
npm run build                 # Production build
```

## Rules
- Cascading search order: SearXNG (3 instances) -> DuckDuckGo Lite -> Brave Search
- 5s timeout per engine, auto-skip on 429/CAPTCHA
- CenterSearchNode is a React Flow node, not an overlay
- Radial layout: 8 results per ring, 300px start radius + 220px per ring
- Domain dedup: max 2 results per domain
- Math evaluation runs client-side before hitting search API
- No emojis

## Deploy
```bash
npx vercel --prod   # nimble.heyitsmejosh.com
```
