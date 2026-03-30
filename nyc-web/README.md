<img src="icon.svg" width="80">

# nyc-web

![version](https://img.shields.io/badge/version-v1.0.0-blue)

Times Square Survival: web port of the colony survival sim. Vanilla HTML5 Canvas, zero dependencies.

## Features

- Colonist AI with health bars, directives, XP/leveling, traits
- Weapons and combat system
- Building placement and demolition
- 3-slot save system (localStorage)
- Interactive tutorial
- Camera pan/zoom (WASD, scroll, touch)
- Mobile touch support (pinch-to-zoom, drag-to-pan)
- Minimap with click-to-navigate

## Run

```bash
python3 -m http.server 8080
```

Open http://localhost:8080

## Controls

| Key | Action |
|-----|--------|
| WASD / Arrows | Pan camera |
| Scroll / Pinch | Zoom |
| Right-drag | Pan camera |
| B | Toggle build menu |
| 1-6 | Select building |
| X | Toggle demolish |
| Space | Pause/resume |
| Ctrl+S | Save |
| Esc | Settings |
| Shift+drag | Box select |

## License

MIT 2026 Joshua Trommel
