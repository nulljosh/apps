# Epiphany

v1.5.0 -- Personal intelligence platform. Palantir for regular people.

## Rules

- Map stays steady -- no jumps on load, no flashing on state changes
- No fake prices before real data arrives
- Mobile-first layout
- Dark mode only, no light/auto theme
- iOS app: four tabs (Situation, Markets, Portfolio, Settings)
- Web app: epiphany.heyitsmejosh.com
- AI endpoint requires ANTHROPIC_API_KEY env var on Vercel
- Never use raw `setInterval` for API polling -- always use `useVisibilityPolling` from `src/hooks/useVisibilityPolling.js`

## Run

```bash
npm install && npm run dev
npm test -- --run
npm run build
```

Deploy: Vercel. Repo: github.com/nulljosh/epiphany

## Key Systems

- **Gateway**: `api/gateway.js` -- critical routes static-imported; everything else lazy-loaded
- **Auth**: `server/api/auth.js`, `server/api/auth-helpers.js`
- **AI**: `server/api/ai.js` (streaming + 10 tools), `src/hooks/useAi.js`, `src/components/AiPanel.jsx`
- **Map**: `src/components/LiveMapBackdrop.jsx` (11 data layers, MapLibre GL)
- **KV**: `server/api/_kv.js` (Upstash Redis) -- trims env var whitespace at load; wraps get/set/del to catch UrlError; always import via getKv(), never @vercel/kv directly
- **Stocks**: `server/api/stocks-free.js` -- **FMP stable API** (`/stable/quote` price/volume/marketCap + `/stable/ratios-ttm` for P/E), fetched per-symbol via `chunkedFetch` (free tier has no batch). The legacy v3 `/quote/{symbols}` batch endpoint was **retired Aug 31 2025** and the Yahoo v7/v10 fallback now returns 401 -- that double failure was the long-standing null market-cap/P/E bug (fixed 2026-05-29). Fresh KV cache is gated on >=50% fundamentals coverage so partial responses don't lock the TTL. Cache key `stocks:free:v2:*`. Web + watchOS use this; iOS/macOS use `server/api/stocks.js` (still on legacy FMP -- migrate to stable for parity). Requires `FMP_API_KEY` in Vercel env.
- **History**: `server/api/history.js` -- Yahoo Finance proxy. Accepts range (1d/5d/1mo/3mo/6mo/1y/2y/5y/10y/ytd/max) + interval (1m/5m/15m/1d etc). iOS maps 1m→(1d,1m), 15m→(5d,15m), max→(max,1d).
- **Avatar**: `server/api/avatar.js` -- accepts JPEG or SVG (`format: 'svg'`), stores to Vercel Blob. Web generates 8-bit pixel art SVG; iOS/macOS use photo picker JPEG. iOS rasterizes SVG avatars via `SVGRasterizer.swift` (WKWebView snapshot) when fetching web-uploaded SVGs.
- **TradingView MCP**: `.mcp.json` wired to `_external/tradingview-mcp/src/server.js` — 78 CDP tools for chart analysis and Pine Script dev. Start TradingView Desktop with `--remote-debugging-port=9222` before using.
- **Landing Page**: `src/pages/LandingPage.jsx` + `src/pages/landing.css` -- shown to unauthenticated visitors before auth flow. Fraunces serif headlines, animated node-graph canvas, scrolling ticker, feature/pricing sections. Gate in `App.jsx` via `showLanding` state.
- **Finance/Roadmap**: `src/components/EpiphanyFinance.jsx` -- replaces RoadmapProjection. Spending history (Oct '25–Apr '26, stacked bar), May tracker with $400 target, 17-year RDSP/TFSA forecast (uses `src/utils/roadmapSim.js`), 5 parameter sliders. Wired to Portfolio → Roadmap tab in FinancePanel.jsx.
- **Roadmap**: `ROADMAP.md`
