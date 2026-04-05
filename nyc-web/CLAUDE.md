# nyc-web

v2.1.1

Times Square Survival with intelligent AI. Vanilla HTML5 Canvas + JS, no bundler, no dependencies. 16-bit sprites, priority-based autoplay AI, auto-quest generation, game phases with victory condition. Claude Code integration via `window._claudeBridge`.

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
- js/claude.js: Claude Code integration bridge
