<img src="icon.svg" width="80" style="border-radius:16px">

# Epiphany.
![version](https://img.shields.io/badge/version-v1.4.0-blue) ![ios](https://img.shields.io/badge/iOS-v1.5.0-blue)

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
- **AI Analyst** Claude-powered streaming chat with 10 tool functions (markets, portfolio, news, ontology, weather, people, alerts, macro, polymarket, statements)
- **Daily Brief** AI-generated morning summary on the Situation tab
- **Macro Pulse** live strip: GDP, CPI, fed rate, yields, VIX, fear/greed
- **Markets** live stock data (FMP + Yahoo Finance), bid/ask/exchange in detail view, 1m/15m/max timeframes, anomaly detection
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

## Roadmap
- [ ] Settings > Connect to tally: fix the broken API route (currently returns 'tally unknown')
- [ ] Stocks view: make it full-screen with an X to dismiss
- [ ] Stocks view: reliably populate market cap and P/E (recurring failure)
- [ ] Flights nearby: stop the intermittent 'flights temporarily unavailable'
