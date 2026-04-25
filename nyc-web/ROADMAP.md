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
- [x] v2.1 4-frame walk animation
- [x] v2.1 Particle effects (damage numbers, XP sparkles, level-up burst, build dust)
- [x] v2.1 Smooth colonist movement (position interpolation)
- [x] v2.1 Colored day/night lighting (dawn orange, sunset amber, night blue)
- [x] v2.1 Difficulty scaling (bosses scale with game phase)
- [x] v2.1 Quest pathfinding fix (path to adjacent tile, not building tile)

## Next (most to least important)

### Must Have
- [ ] Sprite outlines (1px dark border for character definition)
- [ ] Hair/hat variation per colonist (procedural, name hash)
- [ ] Idle animations (breathing bob, head turn)
- [ ] Work animation (arms moving when at quest building)
- [ ] Building interiors (visible when zoomed in close)

### Should Have
- [ ] Weather effects (rain particles, fog overlay)
- [ ] Screen shake on boss spawn
- [ ] Colonist specialization (dedicated gatherers, builders, fighters)
- [ ] Research tree (unlock better buildings and weapons)
- [ ] Sound effects (web audio API -- place, hit, level up, quest done)

### Nice to Have
- [ ] Procedural events (storms, raids, traveling traders)
- [ ] Active Claude hook (auto-feed commits to game)
- [ ] Cross-platform sync (share saves between devices)
- [ ] macOS wallpaper mode
- [ ] Health mirroring (Apple Health -> colonist vitals)
- [ ] Multi-city expansion
- [ ] Multiplayer (shared colony via WebSocket)
