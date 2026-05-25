# grapher-macos

v1.0.0 — Native SwiftUI Mac graphing calculator. Mirrors grapher.heyitsmejosh.com.

## Stack

SwiftUI, macOS 14+, xcodegen, Swift 6. No external dependencies.

## Build

```bash
xcodegen generate && open GrapherMac.xcodeproj
xcodebuild -scheme GrapherMac -destination 'platform=macOS' build
```

## Key Files

- Sources/GrapherMacApp.swift — @main, window commands (Cmd+Shift+N)
- Sources/MacContentView.swift — NavigationSplitView, NSSavePanel PNG export
- Sources/Models/Equation.swift — Codable struct
- Sources/Models/EquationStore.swift — @Observable, UserDefaults persistence
- Sources/Models/GraphMath.swift — NSExpression evaluator
- Sources/Views/MacGraphCanvasView.swift — SwiftUI Canvas, scroll-wheel zoom, drag pan
- Sources/Views/MacEquationListView.swift — sidebar List with TextField + color dot

## Bundle

com.nulljosh.grapher-mac | Team: QMM486NPYC

## Keyboard Shortcuts

- Cmd+Shift+N — Add equation
- + / - — Zoom in/out (when canvas focused)
- Scroll wheel — Zoom
