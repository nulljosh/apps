<img src="icon.svg" width="80">

# Compass iOS

![version](https://img.shields.io/badge/version-v1.0.0-blue)

Native iOS wrapper for the Compass card (TransLink BC) website. Persistent login, tab navigation for balance, card reload, trip history, and account management.

## Features

- Persistent authentication via `WKWebsiteDataStore.default()`
- 4-tab navigation: Home, Reload, Trips, Account
- Loading progress bar
- Pull-to-refresh via toolbar button
- Back/forward gesture support

## Build

```sh
xcodegen generate
open CompassIOS.xcodeproj
```

## Architecture

See [architecture.svg](architecture.svg)

## License

MIT 2026, Joshua Trommel
