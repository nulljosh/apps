# NYC Life Game -- Roadmap

## Completed
- [x] Colony survival sim (colonists, buildings, resources, combat)
- [x] AI autoplay (auto-build, auto-recruit, auto-balance)
- [x] Quest system (CRUD, XP, leveling, categories, classes)
- [x] Dopamine rewards (80/20 roll on quest completion)
- [x] Wallpaper mode (Shift+W) + auto-start + auto-camera
- [x] Streak bonuses (7-day elite recruit, 30-day morale surge)
- [x] Boss encounters (deadline quests spawn boss NPCs)
- [x] Quest viewer (colonist panel shows class, progress, history)
- [x] 50+ tests (quest engine, CRUD, save/load, error handling)
- [x] v2.0 AI overhaul: priority-based decisions, auto-quest generation
- [x] v2.0 16-bit sprites: colonist limbs, skin tones, walk animation, weapons
- [x] v2.0 Building icons: shelter roof, generator lightning, gym dumbbell
- [x] v2.0 Game phases (SURVIVAL > GROWTH > MASTERY > VICTORY)
- [x] v2.0 Claude Code bridge (window._claudeBridge)
- [x] v2.0 Terrain variation (brightness variants, sidewalk details)

## Next Up (v2.1 -- Graphics)
- [ ] Sprite sheet animation (4 frames: idle, walk-left, walk-right, work)
- [ ] Particle effects (damage numbers, XP gain sparkles, build dust)
- [ ] Building interiors (visible through transparent walls when zoomed in)
- [ ] Day/night lighting (orange sunset, blue moonlight, not just dark overlay)
- [ ] Weather effects (rain particles, fog overlay, snow)
- [ ] Smooth colonist movement (interpolated position between ticks)

## Next Up (v2.1 -- Gameplay)
- [ ] Difficulty scaling per phase (enemies get tougher in MASTERY)
- [ ] Colonist specialization (dedicated gatherers, builders, fighters)
- [ ] Trade system between colonists
- [ ] Research tree (unlock better buildings, weapons)
- [ ] Sound effects (web audio API)
- [ ] Active Claude hook (auto-feed file edits and commits to game)

## Future (v3.0)
- [ ] Cross-platform sync
- [ ] macOS wallpaper mode
- [ ] Health mirroring (Apple Health -> colonist vitals)
- [ ] Multi-city expansion
- [ ] Procedural events (storms, raids, traders)
- [ ] Multiplayer (shared colony via WebSocket)
