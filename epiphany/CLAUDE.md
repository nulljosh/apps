# Epiphany

v1.10.3 -- Personal intelligence platform. Palantir for regular people.

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
- **Stocks**: `server/api/stocks-free.js` (web + watchOS) and `server/api/stocks.js` (iOS/macOS). marketCap + P/E come from **Yahoo v10 quoteSummary, authenticated with a cookie+crumb** (`getYahooCrumb()` in `stocks-shared.js`, 1h cached, refresh-on-401). This is the real fix (2026-05-30, v1.10.1/1.10.2): there has never been an `FMP_API_KEY` in prod, and Yahoo v7/v10 now 401 without a crumb -- so every fundamentals source was failing and the pipeline fell to the v8 chart endpoint, which has no marketCap/P/E. Verified live: AAPL marketCap/peRatio non-null, `source:yahoo`. v10 supplement calls are chunked (5 at a time) to dodge Yahoo's 429. FMP path still exists and self-disables when no key is set -- it's an optional override, add `FMP_API_KEY` to Vercel to make it primary. Fresh KV cache gated on >=50% fundamentals coverage. Cache key `stocks:free:v2:*`.
- **History**: `server/api/history.js` -- Yahoo Finance proxy. Accepts range (1d/5d/1mo/3mo/6mo/1y/2y/5y/10y/ytd/max) + interval (1m/5m/15m/1d etc). iOS maps 1m→(1d,1m), 15m→(5d,15m), max→(max,1d).
- **Avatar**: `server/api/avatar.js` -- accepts JPEG or SVG (`format: 'svg'`), stores to Vercel Blob. Web generates 8-bit pixel art SVG; iOS/macOS use photo picker JPEG. iOS rasterizes SVG avatars via `SVGRasterizer.swift` (WKWebView snapshot) when fetching web-uploaded SVGs.
- **Brokerage sync**: `server/api/broker/sync.js` (gateway route `broker/sync`) -- read-only SnapTrade pull of holdings + cash. No-ops with `{ skipped: true }` until `SNAPTRADE_CLIENT_ID` + `SNAPTRADE_CONSUMER_KEY` are set in Vercel. Adapter `src/utils/brokers/snaptrade.js` is read-only (`placeOrder` throws); `getHoldings()` uses `/accounts/{id}/positions` (the combined `/holdings` endpoint was retired by SnapTrade -- 410 Gone, fixed v1.10.0). UI: "Brokerage" tab in `Settings.jsx` -- one button hits `/api/broker/sync`; first call returns `linkUrl` (hosted portal opens in a popup), repeat call returns + renders holdings/cash. Keys live in keychain (`snaptrade-client`/`snaptrade-consumer`, account `epiphany`). Native iOS/macOS parity is a fast-follow (open `linkUrl` via SFSafariViewController).
- **TradingView MCP**: `.mcp.json` wired to `_external/tradingview-mcp/src/server.js` — 78 CDP tools for chart analysis and Pine Script dev. Start TradingView Desktop with `--remote-debugging-port=9222` before using.
- **Landing Page**: `src/pages/LandingPage.jsx` + `src/pages/landing.css` -- shown to unauthenticated visitors before auth flow. Fraunces serif headlines, animated node-graph canvas, scrolling ticker, feature/pricing sections. Gate in `App.jsx` via `showLanding` state.
- **Finance/Roadmap**: `src/components/EpiphanyFinance.jsx` -- replaces RoadmapProjection. Spending history (Oct '25–Apr '26, stacked bar), May tracker with $400 target, 17-year RDSP/TFSA forecast (uses `src/utils/roadmapSim.js`), 5 parameter sliders. Wired to Portfolio → Roadmap tab in FinancePanel.jsx.
- **Roadmap**: `ROADMAP.md`
