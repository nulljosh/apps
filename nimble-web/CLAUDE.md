# Nimble Web
v2.0.0

Instant answers search engine with linear results UI. Merged from Rabbit project.

## Stack
- Vite + React 19
- Vercel serverless function for search API
- Cascading search: SearXNG (3 instances) -> DuckDuckGo Lite -> Brave
- Client-side math evaluation (ported from native Nimble)
- Geist font, Animate.css, dark/light theme
- Apple Liquid Glass aesthetic (frosted glass cards, backdrop-filter blur)

## Structure
- `src/main.jsx` -- Vite entry point
- `src/App.jsx` -- Search UI, results list, state management
- `src/App.css` -- All styles, CSS variables, dark mode, glass morphism
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
- Linear vertical results layout (not mind-map)
- Search bar centered when empty, sticky at top when results shown
- Domain dedup: max 2 results per domain
- Math evaluation runs client-side before hitting search API
- No emojis

## Deploy
```bash
npx vercel --prod   # nimble.heyitsmejosh.com
```
