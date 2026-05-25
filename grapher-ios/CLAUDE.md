# grapher-ios

v1.0.0 — Native SwiftUI iOS graphing calculator. Mirrors grapher.heyitsmejosh.com.

## Stack

SwiftUI, iOS 17+, xcodegen, Swift 6. No external dependencies.

## Build

```bash
xcodegen generate && open GrapherIOS.xcodeproj
xcodebuild -scheme GrapherIOS -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Key Files

- Sources/GrapherApp.swift — app entry, @main
- Sources/ContentView.swift — iPhone VStack / iPad NavigationSplitView layout
- Sources/Models/Equation.swift — Codable struct
- Sources/Models/EquationStore.swift — @Observable, UserDefaults persistence
- Sources/Models/GraphMath.swift — NSExpression evaluator, handles sin/cos/tan/sqrt/log/exp/^
- Sources/Views/GraphCanvasView.swift — SwiftUI Canvas, pinch-zoom + pan gestures
- Sources/Views/EquationListView.swift — List with TextField, color dot, enable toggle, delete

## Bundle

com.nulljosh.grapher-ios | Team: QMM486NPYC

## Color Palette

- bg: #0d0c0b
- text: #f2ede8
- accent: #0071e3 (first equation color)
- equation colors: same 8-color palette as web
