<img src="icon.svg" width="80" style="border-radius:16px">

# Epiphany.
![web](https://img.shields.io/badge/web-v1.10.4-blue) ![ios](https://img.shields.io/badge/iOS-v2.0.2-blue) ![macos](https://img.shields.io/badge/macOS-v1.1.1-blue) ![watchos](https://img.shields.io/badge/watchOS-v1.0.0-blue)

Personal intelligence platform. Map, markets, and people. Palantir for regular people.

[Live](https://epiphany.heyitsmejosh.com) | [Architecture](architecture.svg) | [Whitepaper](WHITEPAPER.md) | [Roadmap](ROADMAP.md)

## Tabs

| Tab | Status |
|---|---|
| Situation | Live map + daily brief + situation monitor + macro pulse |
| Markets | Stocks, crypto, commodities, fear/greed, Polymarket whales |
| Simulator | 60fps trading simulator with Kelly criterion and edge detection |
| Portfolio | Holdings, budgets, debt payoff, spending analysis |
| People | Search and index with relationship graph (AI enrichment deferred) |
| Settings | Theme, ticker, account, billing |

## Features

- **Live Map** with 12 toggleable layers: flights (live + dead-reckoning animation), earthquakes, weather, wildfires, news, incidents, emergency services (fire stations, hospitals, ambulances), dispatch (police/fire/EMS), crime, local events, predictions, heatmap. **Two layers stub-ready, pending API keys:** gas prices + restaurants — see [Roadmap](ROADMAP.md#api-keys-needed).
- **AI Analyst** Claude-powered streaming chat with 10 tool functions (markets, portfolio, news, ontology, weather, people, alerts, macro, polymarket, statements). Reachable from the persistent Ask AI button and Cmd+K.
- **Daily Brief** morning summary on the Situation tab: top movers (Yahoo crumb path) + market headlines + optional one-line AI commentary. Always has content.
- **Macro Pulse** live strip: GDP, CPI, fed rate, yields, VIX, fear/greed (FRED)
- **Markets** live stock data (Yahoo Finance crumb + FMP), bid/ask/exchange in detail view, 1m/15m/max timeframes, anomaly detection
- **Indicators + Signal** RSI, MACD, Bollinger Bands, SMA/EMA/WMA, Stochastic, ATR, plus a Buy/Hold/Sell badge on every stock from a composite of RSI + MACD + MA trend
- **Trading Simulator** 60fps canvas sim with Kelly criterion, edge detection, P&L tracking
- **Portfolio** holdings, debt payoff projections, spending by category, Statements view
- **Prediction Markets** Polymarket with whale tracking and order flow
- **Knowledge Graph** 9 object types, 6 relationship types (Ontology tab)
- **Command Bar** Cmd+K universal search
- **Auth + Billing** Free and Premium ($1/wk via Stripe) tiers — Stripe code wired, price ID pending
- **Landing Page** animated node-graph hero, scrolling ticker, feature/pricing sections
- **PWA** offline service worker
- **Companions** iOS (v1.5.0), macOS, watchOS

## Run

```bash
npm install
npm run dev
npm test -- --run
npm run build
```

Deploy: Vercel (`cd apps/epiphany && npx vercel --prod`)

## License

MIT 2026, Joshua Trommel

## Shipped

Map with 11 live layers, coordinate validation, layer toggles. Live ticker with
static fallback. Stocks via Yahoo crumb path (marketCap and P/E authenticated with
cookie + crumb), full indicator suite plus Buy/Hold/Sell signal badge. Daily brief
rewired off FMP onto the working quote path so it always has content. Macro pulse
from FRED. Polymarket whale tracking. Read-only SnapTrade brokerage sync with
per-position holdings. STALE data indicator. AI Analyst (Claude, 10 tools) with a
persistent entry point. Stripe Free/Premium gate (code complete). Landing page,
PWA, avatar sync across web and native. Palantir-style icon on all platforms.
Monica to Epiphany rename across web, iOS, macOS, watchOS.

Open items live in [ROADMAP.md](ROADMAP.md).
