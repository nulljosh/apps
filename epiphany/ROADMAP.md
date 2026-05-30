# Epiphany Roadmap

Ordered by effort (fewest tokens → most). Ship the top first.

Last updated: 2026-05-30

---

## From 2026-05-30 brain dump (Epiphany.pdf) — open / blocked

Done this pass (see git): daily-brief rewired off FMP onto Yahoo crumb path (fixes
"no data"), Buy/Hold/Sell badge + `src/utils/indicators.js`, persistent Ask AI
button (AI was only reachable via Cmd+K), whitepaper rewritten algorithms-first,
ROADMAP/README cleanup.

Done 2026-05-30:
- **Macro** — valid `FRED_API_KEY` set on Vercel, `/api/macro` returns live series.
- **Flights** — OpenSky OAuth2 client credentials (`OPENSKY_CLIENT_ID` +
  `OPENSKY_CLIENT_SECRET`) set; `flights.js` does the token exchange (Basic auth
  was retired in 2025).

Blocked on keys / accounts (no fake data, cannot self-provision):
- **POI map layers** (coffee, restaurants, gas, groceries, parks, shopping) +
  Google-Maps-style place detail (phone, hours, photo carousel) — endpoints stubbed
  (`places.js`, `pois.js`, `gas.js`); blocked on `GOOGLE_PLACES_API_KEY` /
  `GAS_PRICES_API_KEY`. Existing layers already default on.
- **AI / Daily-brief commentary** — needs `ANTHROPIC_API_KEY` on Vercel.

Open code work:
- **Brokerage auto-sync** — interval pull (~30 min, jittered, backoff) so we are not
  rate-limited; SnapTrade keys are now live on Vercel.
- **iOS/macOS brokerage login** — open SnapTrade `linkUrl` via SFSafariViewController
  (web-only today).
- **iOS markets auto-refresh + retry** — `MarketsView.swift` (stale 30+ min complaint).
- **Spending** — user statement upload UI so uploads permeate the account
  (`EpiphanyFinance.jsx` + PDF importer already exist).
- **Live trading / order placement** — `placeOrder` throws by design; build order
  ticket + keep paper-only until an explicit opt-in.
- **Apple Pay / StoreKit native upgrade** — Stripe gate exists server-side; wire IAP
  for Pro. No custodial banking (regulatory).
- **Tally connect route** — Settings > Connect to tally returns "tally unknown".

---

## Deferred from 2026-05-30 feedback pass (v1.8.0 shipped news cache + macro + real spending)

- **Buy/Sell/Hold badge** on `StockDetail.jsx` from FMP `grades-consensus` / `price-target-consensus` (stable API).
- **TradingView sector heatmap/treemap** (Recharts Treemap) as a Markets sub-tab, sized by mcap, colored by % change.
- **Map Gotham pass**: raise `slice()` item caps in `LiveMapBackdrop.jsx` (12-40/layer), surface layer toggles out of dev-only (`Settings.jsx`), zoom-based density, polish clickable event popups, lock grayscale basemap + drop the toggle so the map shows everything immediately like Google Maps.
- **Ground News-style news**: source-diversity / bias-lean badges + grouping in `news.js` + `NewsWidget.jsx`. Also extend the L2 Upstash cache to the geo/general news path (only the stock path is cached so far).
- **Auth UX**: surface the already-built Apple Sign In (`auth.js` ~line 265) on `LoginPage.jsx`; add TOTP 2FA (Wealthsimple-grade).
- **SnapTrade holdings render**: sync works but `Settings.jsx` shows cash totals only — render per-position symbol/shares/marketValue.
- **iOS/macOS parity**: port real-spending + macro buildout to native (iOS still on legacy `stocks.js`).
- **Price-range prediction** overlay across stocks/commodities/crypto (the "beat the market" research bet).
- **Tally expansion**: show benefits/allowance in the finance panel, not just the payday countdown.
- **Stripe gate is CODE-COMPLETE, verify config**: checkout/webhook/portal/status (`stripe.js`, `stripe-webhook.js`), server enforcement (`gates.js`: `isPro` + 3/day `checkFreeAiLimit` + `ADMIN_EMAILS` bypass), `useSubscription`, `PricingPage`, and the `AiPanel` `upgrade_required` → paywall handoff all exist and work. Open item is config only: confirm `STRIPE_PRICE_ID_STARTER/PRO`, `STRIPE_WEBHOOK_SECRET`, the live webhook endpoint, and a real Stripe product/price exist in Vercel env + Stripe dashboard. No code to write.
- **AI is the only gated feature**: brokerage sync, AI daily brief, and the PDF spending importer are NOT behind Pro. Decide whether to gate any of them or keep AI-only freemium.
- **Map perf after cap bump (v1.9.0)**: marker caps went ~3x; add zoom-based culling in `LiveMapBackdrop.jsx` so dense cities don't render hundreds of markers at low zoom.
- **`mapGrayscale` cleanup**: now a `const true`; the `filter` ternary and the dark/grayscale `setStyle` branch in `LiveMapBackdrop.jsx` can be simplified (subtract-to-add).
- **Native parity for v1.8.0–v1.9.0**: cached news, full macro series, real PDF spending, and the map Gotham pass are web-only; iOS/macOS still on legacy `stocks.js`.
- **Monica/Opticon → Epiphany rename sweep** (~128 refs across 50 files, web + iOS + macOS + watchOS). NOT a blind sed — categorize first:
  - SAFE: display strings, comments, docs (READMEs, WHITEPAPER, index.html title/meta, JSX text).
  - MIGRATE, don't rename: `monica_*` localStorage keys (`monica_last_geo`, `monica_geo_granted`, `monica_broker_config`, `monica_broker_autosend`) and any `monica:*` KV cache keys — rename orphans saved state; needs a read-old-write-new migration shim.
  - DO NOT TOUCH: `com.heyitsmejosh.opticon.pro` / `.ultra` StoreKit product IDs in `ios/Services/StoreKitManager.swift` — registered in App Store Connect, immutable, renaming breaks IAP.
  - REFACTOR: `watchos/MonicaWatchApp.swift` file + `@main` struct rename (Xcode project refs).
  - `.monica-map` / `.monica-map-popup` CSS class + selector pairs must rename together.
  - DONE 2026-05-30: Stripe product "Monica Weekly" → "Epiphany Pro" ($1/wk), price nickname "Epiphany Pro Weekly".
- **Set backend `STRIPE_PRICE_ID_PRO` in Vercel** = `price_1THURbBmnhdgU9sGA4usKDw1` so `getTierFromPriceId` is explicit instead of defaulting every active sub to `pro` (works today, but implicit).

---

## Tier 2 — Map data layer overhaul (major initiative)

**Audit complete 2026-05-23.** Map library: MapLibre GL v5.18.0. Layer toggle infra is solid (CSS display:none, no re-fetch on toggle). Problems are in the data sources. Fix one at a time, test before moving on.

### Layer status

| Layer | Status | Root Cause |
|---|---|---|
| Earthquakes | Real | USGS free feed |
| Weather | Real | Open-Meteo free |
| Wildfires | Real | NASA EONET + FIRMS |
| Incidents | Real | OSM Overpass |
| News/Events | Real (mostly) | GDELT; geocoding bug drops global events |
| Dispatch | US-only | PulsePoint US-only; news RSS fallback for Canada |
| Flights | Real / fake fallback | OpenSky throttles anon → generates fake states |
| Local Events | Sparse | `PREDICTHQ_API_KEY` missing; Wikipedia/OSM only |
| Crime | Fake (Canada) | Google News RSS; no Vancouver/Surrey open data |
| Traffic | Entirely fake | TomTom/HERE keys gone; time-of-day heuristics only |
| AQI | Bug | Markers use `incidents` toggle (wrong `_layerType`) |
| POIs | Missing | Layer doesn't exist — needs Google Places key |
| Gas prices | Missing | Stub endpoint exists, needs API key — see below |
| Restaurants | Missing | Stub endpoint exists, needs API key — see below |

### API keys needed

| Env Var | Service | Cost | Calls/day | Where to get |
|---|---|---|---|---|
| `TOMTOM_API_KEY` | Traffic Flow + Incidents | **Free forever** | 2,500 | developer.tomtom.com |
| `TICKETMASTER_API_KEY` | Local events | **Free** | 5,000 | developer.ticketmaster.com |
| `OPENSKY_USERNAME` + `OPENSKY_PASSWORD` | Flights (less throttle) | **Free account** | ~4,000 | opensky-network.org/index.php/registration |
| `PREDICTHQ_API_KEY` | Events (better data) | Freemium | 100 active | predicthq.com — optional, Ticketmaster covers this |
| `GOOGLE_PLACES_API_KEY` | POIs — restaurants, shops, parks | Paid ($200/mo free credit, ~$0 light use) | varies | [console.cloud.google.com → Maps → Places API (New)](https://console.cloud.google.com/apis/library/places-backend.googleapis.com) |
| `GAS_PRICES_API_KEY` | Gas station prices (BC) | Free tier: 100 req/day | 100/day | [CollectAPI Gas Prices](https://collectapi.com/api/gasPrice/gas-prices-api) — alt: [GasBuddy Data](https://www.gasbuddy.com/developer) (waitlist) |

**Free data sources, no key needed:**
- Vancouver Open Data — crime (`opendata.vancouver.ca`)
- Surrey Open Data CKAN — crime (`data.surrey.ca`)
- USGS, NASA, OSM, GDELT, Open-Meteo — all free, all already integrated

**Note on TomTom:** Traffic.js comment says "keys expired" — the key was deleted, not the service. TomTom free tier is permanent (2,500 req/day, no billing required). Use `TOMTOM_API_KEY`.

### Implementation order

1. **Crime fix** — `server/api/crime.js`
   - Vancouver: `https://opendata.vancouver.ca/api/explore/v2.1/catalog/datasets/crime-data/records?limit=100&geofilter.distance={lat},{lon},5000`
   - Surrey: `https://data.surrey.ca/api/3/action/datastore_search` (verify resource ID)
   - Add before Google News RSS fallback; check if ODS returns lat/lon via `geopoint` field

2. **Events fix** — `server/api/local-events.js`
   - Add Ticketmaster as first source: `https://app.ticketmaster.com/discovery/v2/events.json?apikey={KEY}&latlong={lat},{lon}&radius=50&unit=km&size=50`
   - Only fires if `TICKETMASTER_API_KEY` set

3. **Traffic fix** — `server/api/traffic.js`
   - Replace fake heuristic with TomTom Traffic Flow: `https://api.tomtom.com/traffic/services/4/flowSegmentData/relative0/10/json?point={lat},{lon}&key={TOMTOM_API_KEY}`
   - Map to existing response shape (`congestion`, `currentSpeed`, `freeFlowSpeed`, `confidence`)

5. **POI layer** — three sub-tasks, all blocked on API keys

   **Restaurants + reviews** (needs `GOOGLE_PLACES_API_KEY`)
   - Endpoint stub: `server/api/places.js` — wire to [Google Places Nearby Search (New)](https://developers.google.com/maps/documentation/places/web-service/nearby-search)
   - Request: `POST https://places.googleapis.com/v1/places:searchNearby` with `includedTypes: ["restaurant"]`, `locationRestriction.circle`
   - Response shape: `name`, `rating`, `userRatingCount`, `regularOpeningHours`, `priceLevel`, `googleMapsUri`
   - Cache to Vercel Blob (1 hr TTL); render as teal pins on map; tap → card with rating + hours + "Get Directions"
   - Sign up: [console.cloud.google.com](https://console.cloud.google.com) → APIs & Services → Places API (New) → Create key → restrict to `places-backend.googleapis.com`

   **Gas prices** (needs `GAS_PRICES_API_KEY`)
   - Endpoint stub: `server/api/gas.js` — wire to [CollectAPI Gas Prices](https://collectapi.com/api/gasPrice/gas-prices-api)
   - Request: `GET https://api.collectapi.com/gasPrice/fromCoordinates?lat={lat}&lng={lon}` with `authorization: apikey {key}`
   - Alternative (better BC data): scrape [BC BCAA Fuel Spy](https://www.bcaa.com/resources/fuel-spy) — no key needed, HTML parse of `<table class="fuel-table">`
   - Cache 1 hr; render as orange pin with price badge (e.g. "1.67/L") on map
   - Sign up CollectAPI: [collectapi.com/pricing](https://collectapi.com/pricing) — free tier 100 req/day

   **General POIs** (needs `GOOGLE_PLACES_API_KEY`, same key as restaurants)
   - New: `server/api/pois.js` — Google Places Nearby Search, OSM fallback for types without Places coverage
   - Add `pois: true` to mapLayers state
   - Register in `api/gateway.js`
   - Add fetch + marker render in `LiveMapBackdrop.jsx`

6. **Clustering** — Add `supercluster` npm package
   - Cluster per-layer before rendering markers; re-cluster on zoom change
   - Changes `LiveMapBackdrop.jsx` marker creation blocks

7. **Lazy loading + debouncing**
   - Only fetch layers that are toggled on
   - 500ms debounce on center-change re-fetch trigger

---

## Tier 3 — Medium (1–2 hr)

### Stripe $1/week activation
- Have: `server/api/stripe.js`, `server/api/stripe-webhook.js`, `user.tier` in KV
- Missing: price ID in Stripe dashboard, webhook wired to upgrade tier, feature gates on Premium content
- Create price in Stripe dashboard, set `STRIPE_PRICE_ID` env var, wire webhook

### Ticker items clickable
- Clicking a ticker item only pauses the cycle
- Wire click to open StockDetail view

### FMP API key for iOS/macOS
- `FMP_API_KEY` in Vercel env unblocks market cap, P/E, EPS, beta on iOS
- Add to Vercel env + confirm iOS `stocks.js` route picks it up

### Fix Vercel monorepo deployment
- Check `.vercel/project.json` — run `cd apps/epiphany && vercel link` if wrong org/project
- Audit `nulljosh-9577s-projects` for orphan projects

---

## Tier 4 — Larger features (2+ hr)

### Net Worth + Predictions
- Pull `USER_ACCOUNTS`, `USER_DEBT`, `USER_GOALS`, `USER_INCOME_PHASES` from `userProfile.js` into unified net-worth view
- Chart current net worth over time from portfolio history + projected trajectory
- Run `projectNetWorth()` from `debtProjections.js` using real KV portfolio snapshots
- Show debt-free date, savings milestone dates, surplus trend
- `FinanceDashboard.jsx` has simulation infra — wire in real data

### Data sources expansion
- **Reuters/AP wire** via NewsAPI or Mediastack
- **SEC filings** via EDGAR RSS
- **StatCan** releases, Bank of Canada rate decisions
- **assetmarketcap.com** integration (`server/api/assetmarketcap.js` proxy/cache route)

### Local LLM fallback (Ollama)
- Wire AI panel to Ollama endpoint (`http://localhost:11434/api/generate`)
- Settings model selector: `claude` vs `ollama/gemma4:e2b`
- Gate: health check before showing local option

### AI Enrich (deferred)
- `people-enrich.js` is clean, just needs `ANTHROPIC_API_KEY`
- Hold until provider cost decision is made

---

## Tier 5 — Long-term

### iOS map sources (custom tile overlay)
- Swap SwiftUI `Map {}` for `MKMapView` via `UIViewRepresentable` in `SituationView.swift`
- New `ios/Helpers/MapViewRepresentable.swift` — `MKTileOverlay` for any XYZ tile URL
- Settings picker: 10 presets (OSM, ESRI Satellite, Stamen Terrain, CartoDB Dark, etc.) + custom URL field

### App polish
- TradingView widget embedding (Pine Scripts exist in `tradingview/`)
- Service BC location markers on map (Tally integration)
- Split `App.jsx` into smaller modules (currently 1500+ lines)
- Life section / roadmap projection (connect `RoadmapProjection.jsx` with real milestone data)

### Security + API audit
- Per-service API audit: keep/drop, data populated?, reliable?, safe?
- Tighten CSP, review auth flows

---

## Free vs Premium ($1/wk)

| Free | Premium |
|---|---|
| Map + all data layers | AI Analyst (Claude) |
| Situation monitor | Portfolio + watchlist |
| Stock data + ticker | Ontology writes + batch |
| Weather/quakes | Deep news + crime data |

---

## Shipped

The full shipped list now lives in [README.md](README.md#shipped).
