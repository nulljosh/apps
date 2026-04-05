# Nimble Web
v3.0.0

Instant answers search engine with linear results UI. Merged from Rabbit project.

## Stack
- Vite + React 19
- Vercel serverless functions (search + instant answers)
- Cascading web search: SearXNG (3 instances) -> DuckDuckGo Lite -> Brave
- Instant answers: DuckDuckGo Instant Answer API -> Wikipedia REST API
- Client-side math evaluation with natural language parsing (ported from native Nimble)
- Geist font, Animate.css, dark/light theme
- Apple Liquid Glass aesthetic (frosted glass cards, backdrop-filter blur)

## Structure
- `src/main.jsx` -- Vite entry point
- `src/App.jsx` -- Search UI, results list, state management
- `src/App.css` -- All styles, CSS variables, dark mode, glass morphism
- `src/lib/mathEngine.js` -- Offline math evaluation + natural language math ("nine plus ten" -> 19)
- `src/lib/suggestions.js` -- Rotating placeholder suggestions
- `api/search.js` -- Vercel serverless function, cascading multi-engine web search
- `api/instant.js` -- Vercel serverless function, DDG Instant Answer API + Wikipedia fallback

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
- Math evaluation runs client-side before hitting search API (supports natural language: "nine plus ten")
- Instant answers fetched in parallel with web search (DDG API -> Wikipedia)
- No emojis

## Deploy
```bash
npx vercel --prod   # nimble.heyitsmejosh.com
```
