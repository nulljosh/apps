<img src="icon.svg" width="80">

# Apps

![version](https://img.shields.io/badge/version-v3.0.0-blue)

Monorepo for standalone apps and experiments. Each subdirectory is an independent project.

## Projects

| App | Description | Platform |
|-----|-------------|----------|
| **browser** | Minimal web browser | macOS |
| **browser-ios** | Minimal web browser | iOS |
| **dose** | Health tracker: drugs, vitamins, biometrics | iOS |
| **life** | Game of Life | macOS |
| **life-ios** | Game of Life | iOS |
| **lingo** | Language learning: 39 subjects, 330+ questions | Web (PWA) |
| **nimble** | Instant answers: DuckDuckGo + Wikipedia | macOS |
| **nyc** | Times Square colony survival sim | macOS |
| **nyc-ios** | Times Square colony survival sim | iOS |
| **nyc-web** | Times Square colony survival sim | Web |
| **politics** | Political data explorer | Web |
| **rabbit** | Experimental | -- |
| **roost** | Smart home dashboard | Web |

## Development

Each app has its own build system. SwiftUI apps use xcodegen:

```
cd <app-dir>
xcodegen generate
open *.xcodeproj
```

Web apps run directly from index.html or with a local server.
