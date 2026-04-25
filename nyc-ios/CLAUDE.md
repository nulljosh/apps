# nyc-ios

v0.3.1

## Rules

- Landscape only, no portrait support
- SpriteKit for all rendering
- Touch input: drag pan, pinch zoom, tap select, long press demolish
- No emojis

## Run

```bash
xcodegen generate && open TimesSquareSimIOS.xcodeproj
```

## Test

```bash
xcodegen generate && xcodebuild test -project TimesSquareSimIOS.xcodeproj -scheme TimesSquareSimIOS -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Key Files

- Sources/App/TimesSquareSimApp.swift: SwiftUI entry point that wires the menu and game views.
- Sources/Game/Scenes/GameScene.swift: Main SpriteKit scene with world setup, systems, and update loop.
- Sources/Game/Input/InputHandler.swift: Gesture handling for pan, pinch, tap, and long press.
- Sources/Models/GameState.swift: Central observable state for resources, colonists, and UI flags.
- Sources/Models/SaveManager.swift: Save/load logic for the three-slot JSON save system.
