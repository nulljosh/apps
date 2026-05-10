<img src="public/icon.svg" width="80">

# Nimble Web

![version](https://img.shields.io/badge/version-v3.0.0-blue)

Instant answers search engine with linear results UI.

## Features

- Natural language query understanding ("who is president of X", "population of X", "capital of X")
- Cascading multi-engine search (SearXNG, DuckDuckGo, Brave)
- Instant answers: DDG Answer API (direct factual answers) -> DDG Abstract -> Wikipedia
- Client-side math evaluation (sqrt, sin, cos, tan, log, ln, abs, pow, natural language math)
- Dark/light theme (auto-detects system preference)
- Rotating placeholder suggestions
- Domain deduplication, 5s timeout per engine with auto-fallback

## Run

```bash
npm install
npm run dev
```

## Roadmap
- [ ] Claude design — Apple Liquid Glass aesthetic (backdrop-filter blur, -apple-system font, #0071e3)
- [ ] Bump result quality — richer summaries, better instant answers, structured answer cards
- [ ] iOS/macOS parity with nimble native app

## License

MIT 2026 Joshua Trommel
