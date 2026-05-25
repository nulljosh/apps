<img src="icon.svg" width="80">

# Apps

![version](https://img.shields.io/badge/version-v3.0.0-blue)

Monorepo for standalone apps and experiments. Each subdirectory is an independent project.

## Projects

| App | Description | Platform |
|-----|-------------|----------|
| **beep** | TransLink Compass Card — native iOS app with Face ID, balance/trips dashboard | iOS |
| **beep-web** | TransLink Compass Card — PWA wrapper (iframe) with tab nav and offline state | Web (PWA) |
| **bhaddie** | Location-based social + creator economy | iOS, Web, macOS |
| **brief** | Litigation planning tool (*Trommel v. AG Canada* + *Trommel v. Trommel*). Private. | Web, iOS, macOS |
| **cadence** | Git commit progress tracker across all repos | Web, iOS, macOS |
| **charters** / **charters-ios** | Constitutional Rights Reference — compare rights across 15 constitutions | Web, iOS |
| **dose** | Health tracker: drugs, vitamins, biometrics | Web, iOS, watchOS |
| **echo** | On-device speech transcription via WhisperKit — no cloud, 12 languages | iOS, macOS |
| **epiphany** | Finance + intelligence dashboard | Web, iOS, macOS, watchOS |
| **grapher** | Desmos-style graphing calculator | Web |
| **life** / **life-ios** | Personal life summary for therapy — 32 sections, 27 visuals, dual timeline | Web, iOS |
| **lingo** / **lingo-ios** / **lingo-macos** | Language learning: 39 subjects, 570+ questions | Web (PWA), iOS, macOS |
| **nimble** / **nimble-ios** / **nimble-web** | Instant answers: DuckDuckGo + Wikipedia + mind-map | macOS, iOS, Web |
| **nyc** / **nyc-ios** / **nyc-web** | Times Square colony survival sim | macOS, iOS, Web |
| **parallax** | Head-tracked 3D parallax via webcam + MediaPipe | Web |
| **portfolio-ios** | Portfolio companion | iOS |
| **roost** | Zillow clone for BC — map, listings, filters, agent profiles, price history | Web (PWA) |
| **school** | Grade 12 academic tracker (UVic CS admission) | Web, iOS |
| **spark** | Idea forum with voting, comments, law integration, IP/trademark filing | Web, iOS, macOS, watchOS |
| **tally** | BC Self-Serve scraper + benefits dashboard | Web (PWA), iOS, watchOS |
| **wiretext** / **wiretext-ios** / **wiretext-macos** | Unicode wireframe design tool | Web, iOS, macOS |

## Development

SwiftUI apps use xcodegen:

```bash
cd <app-dir>
xcodegen generate
open *.xcodeproj
```

Vite apps:

```bash
cd <app-dir>
npm install
npm run dev
```

Vanilla/static apps:

```bash
cd <app-dir>
python3 -m http.server 8080
```

Requirements: Xcode 26.2 beta, xcodegen, iOS 17+ / macOS 14+.
