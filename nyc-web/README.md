<img src="icon.svg" width="80">

# nyc-web

![version](https://img.shields.io/badge/version-v2.1.2-blue)

Times Square Survival: colony sim with intelligent AI that can beat itself in under an hour. Vanilla HTML5 Canvas, zero dependencies. 16-bit sprites, priority-based AI, Claude Code integration.

## Features

- Priority-based AI: survival > infrastructure > growth > quests
- Auto-quest generation based on colony state
- Game phases (SURVIVAL > GROWTH > MASTERY > VICTORY)
- Victory condition: 15 alive, avg level 8, one level 10 champion
- 16-bit colonist sprites with limbs, skin tones, walk animation, weapons
- Building icons (shelter roof, generator lightning, gym dumbbell)
- Claude Code bridge (`window._claudeBridge`) for activity integration
- Colonist RPG classes (Warrior, Mage, Rogue, Ranger, Bard, Merchant)
- Weapons and combat system
- Building placement and demolition
- 3-slot save system (localStorage)
- Camera pan/zoom (WASD, scroll, touch, mobile)

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

## Roadmap

- [ ] Difficulty levels — Easy / Medium / Hard selector on new game screen; controls tick rate, resource scarcity, threat frequency
- [ ] UI accessibility — higher contrast HUD text, larger touch targets, better font sizes at small viewport
- [ ] Platform parity — sync iOS (SpriteKit) and macOS targets to match web version feature set
- [ ] Additional platforms — watchOS companion (colony status glance), tvOS big-screen mode

## License

MIT 2026 Joshua Trommel
