// Zero-dependency test runner for nyc-web

import { createColonist, createGameState, grantXP, takeDamage, updateColonistState, colonistXpForNext, colonistXpProgress, createBuilding, createResource,
    questLevel, questTitle, questXPProgress, createQuest, createReward, addQuest, completeQuestInList,
    activeQuests, completedQuests, updatePlayerStreak, DifficultyXP, CategoryInfo, colonistClass,
    randomColonistName, migrateQuestData, currentPhase, checkVictory, GamePhase } from './state.js';
import { generateWorld, GRID_SIZE, TILE_SIZE, tileAt, setTile, worldToTile, tileToWorld, TileType } from './world.js';
import { Pathfinder } from './pathfinder.js';
import { timeTick, canPlace, placeBuilding, demolishBuilding } from './systems.js';
import { Camera } from './camera.js';
import { saveGame, loadGame, listSlots, rebuildGrid, deleteSlot } from './save.js';

let passed = 0;
let failed = 0;
const results = document.getElementById('results');

function suite(name) {
    const div = document.createElement('div');
    div.className = 'suite';
    const title = document.createElement('div');
    title.className = 'suite-name';
    title.textContent = name;
    div.appendChild(title);
    results.appendChild(div);
}

function assert(condition, msg) {
    const div = document.createElement('div');
    div.className = 'test';
    const badge = document.createElement('span');
    badge.className = condition ? 'pass' : 'fail';
    badge.textContent = condition ? 'PASS' : 'FAIL';
    div.appendChild(badge);
    div.appendChild(document.createTextNode(' ' + msg));
    if (condition) passed++; else failed++;
    results.lastChild.appendChild(div);
}

function eq(a, b, msg) { assert(a === b, msg + ' (got ' + a + ', expected ' + b + ')'); }
function approx(a, b, msg, eps) { assert(Math.abs(a - b) < (eps || 0.01), msg + ' (got ' + a + ', expected ~' + b + ')'); }

// ---- state.js ----

suite('state.js -- createColonist');
{
    const c = createColonist('Test', 5, 10);
    assert(c.name === 'Test', 'name set');
    eq(c.col, 5, 'col set');
    eq(c.row, 10, 'row set');
    eq(c.hunger, 100, 'hunger starts at 100');
    eq(c.oxygen, 100, 'oxygen starts at 100');
    eq(c.health, 100, 'health starts at 100');
    eq(c.stress, 0, 'stress starts at 0');
    eq(c.sleep, 100, 'sleep starts at 100');
    eq(c.job, 'idle', 'job starts idle');
    eq(c.state, 'healthy', 'state starts healthy');
    eq(c.weapon, 'fists', 'weapon starts fists');
    eq(c.level, 1, 'level starts at 1');
    eq(c.xp, 0, 'xp starts at 0');
    assert(c.id, 'has id');
    assert(c.trait, 'has trait');
    assert(c.stats.str >= 1 && c.stats.str <= 10, 'str in range');
}

suite('state.js -- createGameState');
{
    const s = createGameState();
    eq(s.resources.food, 20, 'food 20');
    eq(s.resources.materials, 30, 'materials 30');
    assert(Array.isArray(s.colonists), 'colonists is array');
    eq(s.colonists.length, 0, 'no colonists initially');
    eq(s.isPaused, false, 'not paused');
    eq(s.currentTick, 0, 'tick 0');
    eq(s.tutorialStep, 0, 'tutorial step 0');
}

suite('state.js -- grantXP');
{
    const c = createColonist('XP', 0, 0);
    c.level = 1; c.xp = 0; c.trait = 'scavenger';
    grantXP(c, 25);
    eq(c.xp, 25, 'grants 25 xp');
    eq(c.level, 1, 'no level up at 25');
    grantXP(c, 25);
    eq(c.level, 2, 'levels up at 50');
    assert(c.xp < 100, 'xp rolls over after level up');

    const h = createColonist('Hust', 0, 0);
    h.trait = 'hustler'; h.xp = 0; h.level = 1;
    grantXP(h, 50);
    eq(h.level, 2, 'hustler levels up');
    eq(h.xp, 10, 'hustler gets 20% bonus');
}

suite('state.js -- colonistXpForNext');
{
    const c = createColonist('LVL', 0, 0);
    c.level = 1;
    eq(colonistXpForNext(c), 50, 'level 1 needs 50');
    c.level = 5;
    eq(colonistXpForNext(c), 100, 'level 5 needs 100');
    c.level = 10;
    eq(colonistXpForNext(c), 300, 'level 10 needs 300');
}

suite('state.js -- takeDamage');
{
    const c = createColonist('Dmg', 0, 0);
    takeDamage(c, 30);
    eq(c.health, 70, 'takes 30 damage');
    takeDamage(c, 80);
    eq(c.health, 0, 'health floors at 0');
    eq(c.state, 'dead', 'dies at 0 health');
}

suite('state.js -- updateColonistState');
{
    const c = createColonist('State', 0, 0);
    updateColonistState(c);
    eq(c.state, 'healthy', 'healthy at full');
    c.hunger = 10;
    updateColonistState(c);
    eq(c.state, 'hungry', 'hungry below 20');
    c.hunger = 50; c.oxygen = 5;
    updateColonistState(c);
    eq(c.state, 'suffocating', 'suffocating below 20');
    c.oxygen = 50; c.sleep = 10;
    updateColonistState(c);
    eq(c.state, 'exhausted', 'exhausted below 20');
    c.health = 0;
    updateColonistState(c);
    eq(c.state, 'dead', 'dead at 0 health');
    c.health = 100; c.hunger = 100; c.oxygen = 100; c.sleep = 100;
    updateColonistState(c);
    eq(c.state, 'dead', 'dead stays dead');
}

// ---- world.js ----

suite('world.js -- generateWorld');
{
    const { grid, resources } = generateWorld();
    eq(grid.length, GRID_SIZE, 'grid has GRID_SIZE rows');
    eq(grid[0].length, GRID_SIZE, 'grid has GRID_SIZE cols');
    assert(resources.length > 0, 'has resource nodes');
    let hasRoad = false, hasSidewalk = false, hasBuilding = false;
    for (let r = 0; r < GRID_SIZE; r++) {
        for (let c = 0; c < GRID_SIZE; c++) {
            if (grid[r][c] === TileType.road) hasRoad = true;
            if (grid[r][c] === TileType.sidewalk) hasSidewalk = true;
            if (grid[r][c] === TileType.building) hasBuilding = true;
        }
    }
    assert(hasRoad, 'world has roads');
    assert(hasSidewalk, 'world has sidewalks');
    assert(hasBuilding, 'world has buildings');
}

suite('world.js -- tileAt');
{
    const { grid } = generateWorld();
    assert(tileAt(grid, 0, 0) !== null, 'tile at (0,0) exists');
    eq(tileAt(grid, -1, 0), null, 'out of bounds left');
    eq(tileAt(grid, 0, -1), null, 'out of bounds top');
    eq(tileAt(grid, GRID_SIZE, 0), null, 'out of bounds right');
    eq(tileAt(grid, 0, GRID_SIZE), null, 'out of bounds bottom');
}

suite('world.js -- setTile');
{
    const { grid } = generateWorld();
    setTile(grid, 0, 0, TileType.sewer);
    eq(grid[0][0], TileType.sewer, 'tile set correctly');
    setTile(grid, -1, 0, TileType.road);
    assert(true, 'out of bounds setTile does not crash');
}

suite('world.js -- worldToTile');
{
    const t = worldToTile(0, 0);
    eq(t.col, 0, 'world (0,0) -> col 0');
    eq(t.row, 0, 'world (0,0) -> row 0');
    const t2 = worldToTile(TILE_SIZE * 5 + 10, TILE_SIZE * 3 + 5);
    eq(t2.col, 5, 'mid-tile col');
    eq(t2.row, 3, 'mid-tile row');
    const t3 = worldToTile(-100, -100);
    eq(t3.col, 0, 'negative clamps to 0 col');
    eq(t3.row, 0, 'negative clamps to 0 row');
    const t4 = worldToTile(999999, 999999);
    eq(t4.col, GRID_SIZE - 1, 'large clamps to max col');
    eq(t4.row, GRID_SIZE - 1, 'large clamps to max row');
}

// ---- pathfinder.js ----

suite('pathfinder.js');
{
    const { grid } = generateWorld();
    const pf = new Pathfinder();
    pf.buildGraph(grid);
    eq(pf.findPath(0, 0, 0, 0).length, 0, 'same tile returns empty');

    let startC = -1, startR = -1, endC = -1, endR = -1;
    for (let r = 0; r < GRID_SIZE && startC < 0; r++) {
        for (let c = 0; c < GRID_SIZE; c++) {
            if (grid[r][c] === TileType.road) {
                if (startC < 0) { startC = c; startR = r; }
                else if (endC < 0 && (Math.abs(c - startC) + Math.abs(r - startR)) > 3) { endC = c; endR = r; }
            }
            if (endC >= 0) break;
        }
    }
    if (startC >= 0 && endC >= 0) {
        const path = pf.findPath(startC, startR, endC, endR);
        assert(path.length > 0, 'finds path between road tiles');
        assert(path[path.length - 1].col === endC && path[path.length - 1].row === endR, 'path ends at destination');
    }

    let bldgC = -1, bldgR = -1;
    for (let r = 0; r < GRID_SIZE && bldgC < 0; r++) {
        for (let c = 0; c < GRID_SIZE; c++) {
            if (grid[r][c] === TileType.building) { bldgC = c; bldgR = r; break; }
        }
    }
    if (bldgC >= 0) {
        eq(pf.findPath(bldgC, bldgR, bldgC, bldgR + 1).length, 0, 'no path through buildings');
    }
}

// ---- camera.js ----

suite('camera.js');
{
    const cam = new Camera();
    const mc = { width: 800, height: 600 };
    const screen = cam.worldToScreen(500, 300, mc);
    const world = cam.screenToWorld(screen.x, screen.y, mc);
    approx(world.x, 500, 'screenToWorld x round-trip');
    approx(world.y, 300, 'screenToWorld y round-trip');
    cam.zoom = 1.0;
    cam.zoomBy(-5);
    assert(cam.zoom <= cam.maxZoom, 'zoom clamps to maxZoom');
    cam.zoomBy(10);
    assert(cam.zoom >= cam.minZoom, 'zoom clamps to minZoom');
    cam.zoom = 1.0;
    cam.x = GRID_SIZE * TILE_SIZE / 2;
    cam.y = GRID_SIZE * TILE_SIZE / 2;
    const bounds = cam.visibleBounds(mc);
    assert(bounds.minCol >= 0, 'minCol >= 0');
    assert(bounds.minRow >= 0, 'minRow >= 0');
    assert(bounds.maxCol < GRID_SIZE, 'maxCol < GRID_SIZE');
    assert(bounds.maxRow < GRID_SIZE, 'maxRow < GRID_SIZE');
}

// ---- systems.js ----

suite('systems.js -- timeTick');
{
    const s = createGameState();
    eq(timeTick(0.1, s), false, 'no tick at 0.1s');
    eq(s.currentTick, 0, 'tick count unchanged');
    // Note: timeTick uses a module-level accumulator, so we need enough dt
    eq(timeTick(0.91, s), true, 'ticks after 1s accumulated');
    eq(s.currentTick, 1, 'tick count incremented');
    s.isPaused = true;
    eq(timeTick(2.0, s), false, 'no tick when paused');
}

suite('systems.js -- canPlace');
{
    const { grid } = generateWorld();
    const s = createGameState();
    s.resources.materials = 100; s.resources.cash = 100; s.resources.power = 100;

    let roadC = -1, roadR = -1;
    for (let r = 0; r < GRID_SIZE && roadC < 0; r++) {
        for (let c = 0; c < GRID_SIZE - 1; c++) {
            if (grid[r][c] === TileType.road && grid[r][c + 1] === TileType.road &&
                r + 1 < GRID_SIZE && grid[r + 1][c] === TileType.road && grid[r + 1][c + 1] === TileType.road) {
                roadC = c; roadR = r; break;
            }
        }
    }
    if (roadC >= 0) assert(canPlace('shelter', roadC, roadR, grid, s), 'can place shelter on road');

    let bldC = -1, bldR = -1;
    for (let r = 0; r < GRID_SIZE && bldC < 0; r++) {
        for (let c = 0; c < GRID_SIZE; c++) {
            if (grid[r][c] === TileType.building) { bldC = c; bldR = r; break; }
        }
    }
    if (bldC >= 0) assert(!canPlace('shelter', bldC, bldR, grid, s), 'cannot place on building tile');
    s.resources.materials = 0;
    if (roadC >= 0) assert(!canPlace('shelter', roadC, roadR, grid, s), 'cannot place without resources');
}

// ---- save.js ----

suite('save.js -- save/load round-trip');
{
    const { grid } = generateWorld();
    const s = createGameState();
    s.colonists.push(createColonist('SaveTest', 10, 20));
    s.resources.food = 42;
    s.currentTick = 99;
    deleteSlot(3);
    saveGame(3, s, grid);
    const loaded = loadGame(3);
    assert(loaded !== null, 'loaded save is not null');
    eq(loaded.resources.food, 42, 'food preserved');
    eq(loaded.currentTick, 99, 'tick preserved');
    eq(loaded.colonists.length, 1, 'colonist count preserved');
    eq(loaded.colonists[0].name, 'SaveTest', 'colonist name preserved');
    const rebuilt = rebuildGrid(loaded);
    eq(rebuilt.length, grid.length, 'grid size preserved');
    eq(rebuilt[0][0], grid[0][0], 'grid tile [0][0] preserved');
    const slots = listSlots();
    assert(slots[2] !== null, 'slot 3 listed');
    eq(slots[2].colonistCount, 1, 'slot shows 1 colonist');
    try { localStorage.setItem('nyc_save_99', 'not json{'); } catch {}
    eq(loadGame(99), null, 'corrupt data returns null');
    try { localStorage.removeItem('nyc_save_99'); } catch {}
    deleteSlot(3);
}

// ---- Quest System Tests ----

suite('Quest XP Engine');
{
    eq(questLevel(0), 0, 'level 0 at 0 XP');
    eq(questLevel(50), 1, 'level 1 at 50 XP');
    eq(questLevel(200), 2, 'level 2 at 200 XP');
    eq(questLevel(450), 3, 'level 3 at 450 XP');
    eq(questLevel(5000), 10, 'level 10 at 5000 XP');
    eq(questTitle(0), 'Squire', 'title Squire at level 0');
    eq(questTitle(1), 'Knight', 'title Knight at level 1');
    eq(questTitle(100), 'Mythic', 'title Mythic at high level');
    const prog = questXPProgress(75);
    eq(prog.level, 1, 'progress level correct');
    assert(prog.progress === 25, 'progress amount correct');
    assert(prog.needed === 150, 'needed amount correct');
}

suite('Quest Difficulty XP');
{
    eq(DifficultyXP.F, 10, 'F rank = 10 XP');
    eq(DifficultyXP.D, 25, 'D rank = 25 XP');
    eq(DifficultyXP.C, 50, 'C rank = 50 XP');
    eq(DifficultyXP.B, 100, 'B rank = 100 XP');
    eq(DifficultyXP.A, 200, 'A rank = 200 XP');
    eq(DifficultyXP.S, 500, 'S rank = 500 XP');
}

suite('Quest CRUD');
{
    const state = createGameState();
    const q = addQuest(state, { title: 'Test Quest', difficulty: 'B', category: 'work' });
    eq(state.questList.length, 1, 'quest added to list');
    eq(q.title, 'Test Quest', 'quest title correct');
    eq(q.difficulty, 'B', 'quest difficulty correct');
    eq(q.category, 'work', 'quest category correct');
    assert(!q.completed, 'quest starts incomplete');
    eq(activeQuests(state).length, 1, '1 active quest');
    eq(completedQuests(state).length, 0, '0 completed quests');

    const result = completeQuestInList(state, q.id);
    assert(result !== null, 'complete returns result');
    eq(result.xp, 100, 'B rank gives 100 XP');
    eq(state.playerXP, 100, 'player XP updated');
    eq(activeQuests(state).length, 0, '0 active after complete');
    eq(completedQuests(state).length, 1, '1 completed after complete');

    // Double-complete returns null
    eq(completeQuestInList(state, q.id), null, 'double complete returns null');
    // Complete nonexistent returns null
    eq(completeQuestInList(state, 'fake-id'), null, 'fake id returns null');
}

suite('Quest Categories & Classes');
{
    assert(CategoryInfo.fitness.className === 'Warrior', 'fitness = Warrior');
    assert(CategoryInfo.study.className === 'Mage', 'study = Mage');
    assert(CategoryInfo.work.className === 'Rogue', 'work = Rogue');
    assert(CategoryInfo.personal.className === 'Ranger', 'personal = Ranger');
    assert(CategoryInfo.creative.className === 'Bard', 'creative = Bard');
    assert(CategoryInfo.errand.className === 'Merchant', 'errand = Merchant');

    const c = createColonist('ClassTest', 0, 0);
    assert(colonistClass(c) === null, 'no class without quests');
    c.dominantCategory = 'fitness';
    eq(colonistClass(c), 'Warrior', 'class from dominant category');
}

suite('Quest Rewards');
{
    const state = createGameState();
    state.rewardList = [createReward('Coffee break'), createReward('10 min gaming')];
    addQuest(state, { title: 'Reward Test', difficulty: 'C', category: 'personal' });

    // Complete -- should either set toast or not (80/20)
    completeQuestInList(state, state.questList[0].id);
    // Toast message should exist (either reward or "gods demand more")
    assert(state.toastMessage !== null, 'toast message set on completion');
    assert(state.toastMessage.text.length > 0, 'toast has text');
}

suite('Player Streak');
{
    const state = createGameState();
    updatePlayerStreak(state);
    eq(state.playerStreak, 1, 'first activity sets streak to 1');
    assert(state.playerLastActive !== null, 'lastActive set');

    // Same day -- no change
    const streak = state.playerStreak;
    updatePlayerStreak(state);
    eq(state.playerStreak, streak, 'same day no streak change');
}

suite('Quest Factory');
{
    const q = createQuest({ title: 'Factory Test', difficulty: 'A', category: 'study' });
    assert(q.id.length > 0, 'quest has UUID');
    eq(q.title, 'Factory Test', 'title set');
    eq(q.difficulty, 'A', 'difficulty set');
    eq(q.category, 'study', 'category set');
    assert(!q.completed, 'starts not completed');
    assert(q.createdAt.length > 0, 'has timestamp');

    const r = createReward('Free snack');
    assert(r.id.length > 0, 'reward has UUID');
    eq(r.text, 'Free snack', 'reward text set');
    assert(r.active, 'reward starts active');
}

suite('Colonist Name Generation');
{
    const existing = [createColonist('Alex', 0, 0), createColonist('Jordan', 0, 0)];
    const name = randomColonistName(existing);
    assert(name !== 'Alex' && name !== 'Jordan', 'avoids existing names');
    assert(name.length > 0, 'returns a name');
}

suite('Quest Data Migration');
{
    const state = createGameState();
    // Simulate standalone Quest app data
    try {
        localStorage.setItem('quest:quests', JSON.stringify([{ id: 'migrate-1', title: 'Migrated', completed: false }]));
        localStorage.setItem('quest:profile', JSON.stringify({ totalXP: 500, currentStreak: 3, lastActiveDate: '2026-04-04' }));
        localStorage.setItem('quest:rewards', JSON.stringify([{ id: 'r1', text: 'Migrate reward', active: true }]));
    } catch {}
    migrateQuestData(state);
    eq(state.questList.length, 1, 'quests migrated');
    eq(state.questList[0].title, 'Migrated', 'quest title migrated');
    eq(state.playerXP, 500, 'XP migrated');
    eq(state.playerStreak, 3, 'streak migrated');
    eq(state.rewardList.length, 1, 'rewards migrated');
    // Cleanup
    try {
        localStorage.removeItem('quest:quests');
        localStorage.removeItem('quest:profile');
        localStorage.removeItem('quest:rewards');
    } catch {}
}

suite('Quest Save/Load');
{
    const state = createGameState();
    addQuest(state, { title: 'Save Test Quest', difficulty: 'S', category: 'fitness' });
    state.playerXP = 1234;
    state.playerStreak = 7;
    const { grid } = generateWorld();
    deleteSlot(3);
    saveGame(3, state, grid);
    const loaded = loadGame(3);
    assert(loaded !== null, 'quest save loads');
    assert(loaded.questList !== undefined, 'questList in save');
    eq(loaded.questList.length, 1, 'quest preserved in save');
    eq(loaded.questList[0].title, 'Save Test Quest', 'quest title in save');
    eq(loaded.playerXP, 1234, 'playerXP in save');
    eq(loaded.playerStreak, 7, 'playerStreak in save');
    deleteSlot(3);
}

suite('Error Handling');
{
    // createQuest with missing fields
    const q = createQuest({ title: 'Minimal' });
    eq(q.difficulty, 'C', 'default difficulty C');
    eq(q.category, 'personal', 'default category personal');
    eq(q.notes, '', 'default empty notes');
    assert(q.dueDate === null, 'default null dueDate');

    // questLevel with negative XP
    eq(questLevel(-100), 0, 'negative XP gives level 0');

    // questTitle with negative level
    eq(questTitle(-5), 'Squire', 'negative level gives Squire');

    // completeQuestInList with empty state
    const emptyState = createGameState();
    eq(completeQuestInList(emptyState, 'nonexistent'), null, 'complete on empty state returns null');

    // DifficultyXP unknown rank
    assert(DifficultyXP['Z'] === undefined, 'unknown rank is undefined');

    // colonistClass with null category
    const c = createColonist('Test', 0, 0);
    c.dominantCategory = 'nonexistent';
    assert(colonistClass(c) === null, 'unknown category returns null class');
}

suite('Game Phases & Victory');
{
    const state = createGameState();
    eq(currentPhase(state), GamePhase.SURVIVAL, 'empty state is SURVIVAL');
    eq(checkVictory(state), false, 'no victory with no colonists');

    // Add 5 colonists -> GROWTH
    for (let i = 0; i < 5; i++) state.colonists.push(createColonist(`P${i}`, 0, 0));
    eq(currentPhase(state), GamePhase.GROWTH, '5 colonists = GROWTH');

    // Add 10 with avg level 5 -> MASTERY
    for (let i = 0; i < 5; i++) state.colonists.push(createColonist(`Q${i}`, 0, 0));
    for (const c of state.colonists) c.level = 5;
    eq(currentPhase(state), GamePhase.MASTERY, '10 colonists avg level 5 = MASTERY');

    // Add 15 with avg level 8 -> VICTORY phase
    for (let i = 0; i < 5; i++) state.colonists.push(createColonist(`R${i}`, 0, 0));
    for (const c of state.colonists) c.level = 8;
    eq(currentPhase(state), GamePhase.VICTORY, '15 colonists avg level 8 = VICTORY');

    // Victory requires one level 10
    eq(checkVictory(state), false, 'no victory without level 10');
    state.colonists[0].level = 10;
    eq(checkVictory(state), true, 'victory with level 10 champion');
}

suite('createReward');
{
    const r = createReward('Coffee break');
    assert(r.id.length > 0, 'reward has id');
    eq(r.text, 'Coffee break', 'text set');
    eq(r.active, true, 'starts active');
}

// ---- Summary ----

const summary = document.getElementById('summary');
const total = passed + failed;
summary.className = failed === 0 ? 'pass' : 'fail';
summary.textContent = passed + '/' + total + ' passed' + (failed > 0 ? ' (' + failed + ' failed)' : ' -- all green');
