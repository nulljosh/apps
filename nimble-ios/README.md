<img src="../nimble/icon.svg" width="80">

# Nimble iOS

![version](https://img.shields.io/badge/version-v1.0.0-blue)

iOS companion for [Nimble](../nimble/), the instant-answers app. SwiftUI, no API keys required.

## Features

- Instant search with DuckDuckGo + Wikipedia
- Offline math evaluation (trig, sqrt, log, powers, pi)
- 8 color themes with haptic feedback
- Copy result text, open in Safari
- Rotating placeholder suggestions

## Development

Requires Xcode and [xcodegen](https://github.com/yonaskolb/XcodeGen).

```bash
xcodegen generate
open NimbleIOS.xcodeproj
```

Target simulator: `iPhone 17 Pro`

## Roadmap

### v1.1.0 -- Polish
- Search history with recent queries list
- Share sheet for results
- Haptic refinement (different patterns per result type)
- Landscape layout optimization
- iPad layout with wider search bar

### v1.2.0 -- Smart Answers
- Unit conversion (length, weight, temperature, volume)
- Currency conversion via free exchange rate API
- Timezone queries ("time in Tokyo")
- Color preview for hex/rgb values
- Voice input via SFSpeechRecognizer

### v1.3.0 -- Widgets & Shortcuts
- iOS widgets (small: last answer, medium: search bar)
- Lock Screen widget with quick search
- Siri Shortcuts integration
- Spotlight indexing for search history

### v2.0.0 -- Multi-Source
- Pluggable answer sources (Wolfram|Alpha, OpenAI, custom)
- Bookmarks/favorites for frequent queries
- iCloud sync for preferences and history across macOS/iOS
- Apple Watch companion (quick voice search)

## License

MIT 2026 Joshua Trommel
