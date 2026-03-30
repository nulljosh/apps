# nyc-web

v1.2.0

Web port of Times Square Survival. Vanilla HTML5 Canvas + JS, no bundler, no dependencies. Apple Liquid Glass UI with rounded tiles, frosted glass HUD, and unified SF color palette.

## Run

```bash
python3 -m http.server 8080
# Open http://localhost:8080
```

## Rules

- No frameworks, no bundlers -- vanilla JS with ES modules
- Canvas for game rendering, HTML overlays for HUD
- Mobile-first touch support (pinch zoom, drag pan)
- Save to localStorage (3 slots, same as native)

## Key Files

- index.html: Entry point
- js/main.js: Game loop, init, menu
- js/state.js: Game state models (colonists, buildings, resources)
- js/world.js: Tile map, world generator
- js/systems.js: All game systems (time, needs, resources, build, jobs)
- js/pathfinder.js: BFS pathfinding
- js/renderer.js: Canvas drawing
- js/camera.js: Pan/zoom camera
- js/input.js: Keyboard, mouse, touch input
- js/hud.js: HTML HUD overlays
- js/save.js: localStorage save/load
