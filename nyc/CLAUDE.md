# nyc

v1.0.0

## Rules

- Landscape only, no portrait support
- SpriteKit for all rendering, no UIKit views in game scene
- No emojis

## Run

```bash
xcodegen generate && open TimesSquareSim.xcodeproj
```

## Key Files

- Sources/App/TimesSquareSimApp.swift: App entry point and scene setup
- Sources/Game/Scenes/GameScene.swift: Main gameplay scene loop and orchestration
- Sources/Game/World/WorldGenerator.swift: Generates the Times Square map layout
- Sources/Game/Entities/Colonist.swift: Colonist behavior, stats, and state
- Sources/Game/Systems/BuildSystem.swift: Placement and demolition logic
- Sources/Models/SaveManager.swift: Save/load handling for game state
