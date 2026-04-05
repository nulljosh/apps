// Game systems -- NeedsSystem, TimeSystem, ResourceSystem, BuildSystem, JobSystem

import { grantXP, takeDamage, updateColonistState, gameLog, createBuilding, createColonist, WeaponTypes, BuildingType, syncQuests, QuestBuildings } from './state.js';
import { TileType, tileAt, setTile, GRID_SIZE } from './world.js';

// TimeSystem
const TICKS_PER_DAY = 240;
let accumulated = 0;
const TICK_INTERVAL = 1.0;

export function timeTick(dt, state) {
    if (state.isPaused) return false;
    accumulated += dt;
    if (accumulated >= TICK_INTERVAL) {
        accumulated -= TICK_INTERVAL;
        state.currentTick++;
        state.currentHour = Math.floor((state.currentTick % TICKS_PER_DAY) / 10);
        state.isNight = state.currentHour >= 20 || state.currentHour < 6;
        return true;
    }
    return false;
}

// NeedsSystem
const GRACE_PERIOD = 120;

export function needsTick(state) {
    const inGrace = state.currentTick < GRACE_PERIOD;

    for (let i = 0; i < state.colonists.length; i++) {
        const c = state.colonists[i];
        if (c.state === 'dead') continue;

        if (!inGrace) {
            const endMult = 1.0 - c.stats.end * 0.05;
            const sleepMult = c.trait === 'insomniac' ? 0.7 : 1.0;
            const o2Mult = c.trait === 'ironlung' ? 0.7 : 1.0;
            const stressMult = c.trait === 'anxious' ? 2.0 : 1.0;

            c.hunger = Math.max(0, c.hunger - 0.25 * endMult);
            c.oxygen = Math.max(0, c.oxygen - 0.1 * o2Mult);
            c.stress = Math.min(100, c.stress + 0.15 * stressMult);
            c.sleep = Math.max(0, c.sleep - 0.15 * sleepMult);
        }

        // CHA stress reduction from nearby colonists
        for (let j = 0; j < state.colonists.length; j++) {
            if (j === i || state.colonists[j].state === 'dead') continue;
            const dist = Math.abs(state.colonists[j].col - c.col) + Math.abs(state.colonists[j].row - c.row);
            if (dist <= 3) c.stress = Math.max(0, c.stress - c.stats.cha * 0.02);
        }

        // Building effects
        for (const b of state.buildings) {
            if (!b.isActive) continue;
            const dist = Math.abs(b.col - c.col) + Math.abs(b.row - c.row);
            if (dist > 3) continue;

            switch (b.type) {
                case 'shelter':
                    c.stress = Math.max(0, c.stress - 0.5);
                    c.sleep = Math.min(100, c.sleep + 0.4);
                    break;
                case 'foodStall':
                    if ((state.resources.food || 0) > 0) {
                        c.hunger = Math.min(100, c.hunger + 2.0);
                        state.resources.food--;
                    }
                    break;
                case 'filterStation':
                    if ((state.resources.power || 0) > 0) {
                        c.oxygen = Math.min(100, c.oxygen + 1.0);
                    }
                    break;
                case 'generator':
                    state.resources.power = (state.resources.power || 0) + 1;
                    break;
                case 'billboard':
                    state.resources.cash = (state.resources.cash || 0) + 1;
                    break;
            }
        }

        updateColonistState(c);
        if (c.state === 'dead') gameLog(state, `${c.name} has died`);
    }
}

// ResourceSystem
export function resourceTick(state) {
    for (const rn of state.resourceNodes) {
        if (rn.remaining <= 0) {
            rn.ticksSinceDepleted++;
            if (rn.ticksSinceDepleted >= rn.respawnTicks) {
                rn.remaining = rn.maxAmount;
                rn.ticksSinceDepleted = 0;
            }
        }
    }

    for (const c of state.colonists) {
        if (c.job !== 'gather' || c.state === 'dead') continue;
        for (const rn of state.resourceNodes) {
            if (rn.remaining <= 0) continue;
            const dist = Math.abs(rn.col - c.col) + Math.abs(rn.row - c.row);
            if (dist <= 1) {
                const taken = Math.min(1, rn.remaining);
                rn.remaining -= taken;
                if (taken > 0) state.resources[rn.type] = (state.resources[rn.type] || 0) + taken;
                break;
            }
        }
    }
}

// BuildSystem
export function canPlace(type, col, row, grid, state) {
    const bt = BuildingType[type];
    const [w, h] = bt.size;
    for (let r = row; r < row + h; r++) {
        for (let c = col; c < col + w; c++) {
            const t = tileAt(grid, c, r);
            if (t === null || !isWalkable(t)) return false;
        }
    }
    for (const [res, amt] of Object.entries(bt.cost)) {
        if ((state.resources[res] || 0) < amt) return false;
    }
    return true;
}

function isWalkable(t) { return t === TileType.road || t === TileType.sidewalk || t === TileType.subway; }

export function placeBuilding(type, col, row, grid, state, pathfinder) {
    if (!canPlace(type, col, row, grid, state)) return null;
    const bt = BuildingType[type];
    for (const [res, amt] of Object.entries(bt.cost)) {
        state.resources[res] -= amt;
    }
    const [w, h] = bt.size;
    for (let r = row; r < row + h; r++) {
        for (let c = col; c < col + w; c++) {
            setTile(grid, c, r, TileType.building);
            pathfinder.removeNode(c, r);
        }
    }
    const model = createBuilding(type, col, row);
    state.buildings.push(model);
    gameLog(state, `Built ${bt.name}`);
    return model;
}

export function demolishBuilding(id, grid, state, pathfinder) {
    const idx = state.buildings.findIndex(b => b.id === id);
    if (idx === -1) return;
    const b = state.buildings[idx];
    const bt = BuildingType[b.type];
    const [w, h] = bt.size;
    for (let r = b.row; r < b.row + h; r++) {
        for (let c = b.col; c < b.col + w; c++) {
            setTile(grid, c, r, TileType.sidewalk);
            pathfinder.addNode(c, r);
        }
    }
    state.buildings.splice(idx, 1);
    gameLog(state, `Demolished ${bt.name}`);
}

// JobSystem
export function jobTick(state, pathfinder) {
    autoAssignIdle(state, pathfinder);

    for (let i = 0; i < state.colonists.length; i++) {
        const c = state.colonists[i];
        if (c.state === 'dead') continue;

        if (c.job === 'attack') {
            tickCombat(i, state, pathfinder);
        }

        if (c.pathIndex >= c.pathCols.length) {
            if (c.job === 'gather') {
                grantXP(c, 5);
                assignRandomGatherTarget(i, state);
            } else if (c.job === 'patrol') {
                assignRandomPatrolTarget(i, state, pathfinder);
            }
            continue;
        }

        const speed = Math.max(1, Math.floor(1.0 + c.stats.agi * 0.1));
        for (let s = 0; s < speed; s++) {
            if (c.pathIndex >= c.pathCols.length) break;
            c.col = c.pathCols[c.pathIndex];
            c.row = c.pathRows[c.pathIndex];
            c.pathIndex++;
        }
    }
}

function autoAssignIdle(state, pathfinder) {
    if (state.currentDirective === 'idle') return;

    for (let i = 0; i < state.colonists.length; i++) {
        const c = state.colonists[i];
        if (c.state === 'dead' || c.job !== 'idle' || c.jobOverride) continue;

        switch (state.currentDirective) {
            case 'gather': assignNearestGatherTarget(i, state, pathfinder); break;
            case 'build':  assignNearestBuildTarget(i, state, pathfinder); break;
            case 'patrol': assignRandomPatrolTarget(i, state, pathfinder); break;
        }
    }
}

function assignNearestGatherTarget(i, state, pathfinder) {
    const c = state.colonists[i];
    const available = state.resourceNodes.filter(r => r.remaining > 0);
    if (!available.length) return;
    available.sort((a, b) =>
        (Math.abs(a.col - c.col) + Math.abs(a.row - c.row)) -
        (Math.abs(b.col - c.col) + Math.abs(b.row - c.row))
    );
    const target = available[0];
    const path = pathfinder.findPath(c.col, c.row, target.col, target.row);
    if (!path.length) return;
    c.job = 'gather';
    c.pathCols = path.map(p => p.col);
    c.pathRows = path.map(p => p.row);
    c.pathIndex = 0;
}

function assignNearestBuildTarget(i, state, pathfinder) {
    const c = state.colonists[i];
    const unfinished = state.buildings.filter(b => !b.isActive);
    if (!unfinished.length) { assignRandomPatrolTarget(i, state, pathfinder); return; }
    unfinished.sort((a, b) =>
        (Math.abs(a.col - c.col) + Math.abs(a.row - c.row)) -
        (Math.abs(b.col - c.col) + Math.abs(b.row - c.row))
    );
    const target = unfinished[0];
    const path = pathfinder.findPath(c.col, c.row, target.col, target.row);
    if (!path.length) return;
    c.job = 'build';
    c.pathCols = path.map(p => p.col);
    c.pathRows = path.map(p => p.row);
    c.pathIndex = 0;
}

function assignRandomPatrolTarget(i, state, pathfinder) {
    const c = state.colonists[i];
    const destCol = Math.max(0, Math.min(GRID_SIZE - 1, c.col + Math.floor(Math.random() * 31) - 15));
    const destRow = Math.max(0, Math.min(GRID_SIZE - 1, c.row + Math.floor(Math.random() * 31) - 15));
    const path = pathfinder.findPath(c.col, c.row, destCol, destRow);
    if (path.length) {
        c.job = 'patrol';
        c.pathCols = path.map(p => p.col);
        c.pathRows = path.map(p => p.row);
        c.pathIndex = 0;
    }
}

function assignRandomGatherTarget(i, state) {
    const available = state.resourceNodes.filter(r => r.remaining > 0);
    if (!available.length) return;
    const target = available[Math.floor(Math.random() * available.length)];
    const c = state.colonists[i];
    const dist = Math.abs(target.col - c.col) + Math.abs(target.row - c.row);
    if (dist > 2) {
        c.pathCols = [target.col];
        c.pathRows = [target.row];
        c.pathIndex = 0;
    }
}

// AutoplaySystem -- AI that builds, recruits, and balances directives
const AUTOPLAY_INTERVAL = 30; // ticks between AI decisions

export function autoplayTick(state, grid, pathfinder, placeBuildingFn) {
    if (!state.autoplay) return;
    if (state.currentTick % AUTOPLAY_INTERVAL !== 0) return;

    const alive = state.colonists.filter(c => c.state !== 'dead');
    const res = state.resources;
    const buildings = state.buildings;

    // Count building types
    const counts = {};
    for (const b of buildings) counts[b.type] = (counts[b.type] || 0) + 1;

    // Assess colony needs
    const avgHunger = alive.reduce((s, c) => s + c.hunger, 0) / (alive.length || 1);
    const avgOxygen = alive.reduce((s, c) => s + c.oxygen, 0) / (alive.length || 1);
    const avgStress = alive.reduce((s, c) => s + c.stress, 0) / (alive.length || 1);
    const avgSleep = alive.reduce((s, c) => s + c.sleep, 0) / (alive.length || 1);

    // Priority: what to build next
    let buildType = null;

    if (avgHunger < 40 && (res.food || 0) < 5) {
        // Need food -- gather more, build food stall if we can
        if (!counts.foodStall || counts.foodStall < Math.ceil(alive.length / 3)) {
            buildType = 'foodStall';
        }
        state.currentDirective = 'gather';
    } else if ((res.power || 0) < 3 || avgOxygen < 50) {
        if (!counts.generator || counts.generator < 2) {
            buildType = 'generator';
        }
        if (!counts.filterStation) buildType = 'filterStation';
    } else if (avgStress > 60 || avgSleep < 30) {
        if (!counts.shelter || counts.shelter < Math.ceil(alive.length / 3)) {
            buildType = 'shelter';
        }
    } else if ((res.cash || 0) < 10) {
        if (!counts.billboard || counts.billboard < 2) {
            buildType = 'billboard';
        }
        state.currentDirective = 'gather';
    } else {
        // Stable -- alternate between gather and patrol
        state.currentDirective = state.currentTick % 60 < 30 ? 'gather' : 'patrol';
    }

    // Try to place building if we decided on one
    if (buildType && placeBuildingFn) {
        const bt = BuildingType[buildType];
        const [w, h] = bt.size;

        // Check if we can afford it
        let canAfford = true;
        for (const [r, amt] of Object.entries(bt.cost)) {
            if ((res[r] || 0) < amt) { canAfford = false; break; }
        }

        if (canAfford) {
            // Find a valid placement near colony center
            const centerCol = Math.round(alive.reduce((s, c) => s + c.col, 0) / alive.length);
            const centerRow = Math.round(alive.reduce((s, c) => s + c.row, 0) / alive.length);

            for (let radius = 2; radius < 15; radius++) {
                let placed = false;
                for (let dc = -radius; dc <= radius && !placed; dc++) {
                    for (let dr = -radius; dr <= radius && !placed; dr++) {
                        const col = centerCol + dc;
                        const row = centerRow + dr;
                        if (col < 0 || row < 0 || col + w >= GRID_SIZE || row + h >= GRID_SIZE) continue;
                        if (canPlace(buildType, col, row, grid, state)) {
                            placeBuildingFn(buildType, col, row);
                            placed = true;
                        }
                    }
                }
                if (placed) break;
            }
        }
    }

    // Auto-recruit: spawn colonist if resources allow and colony is stable
    if (alive.length < 15 && avgHunger > 60 && avgOxygen > 60 && (res.food || 0) > 10 && (res.materials || 0) > 5) {
        if (state.currentTick % (AUTOPLAY_INTERVAL * 3) === 0) {
            const names = ['Sam', 'Taylor', 'Avery', 'Quinn', 'Blake', 'Charlie', 'Drew', 'Emery', 'Finley', 'Harper'];
            const name = names[alive.length % names.length];
            const spawnC = alive[0];
            if (spawnC) {
                    state.colonists.push(createColonist(name, spawnC.col + 1, spawnC.row));
                gameLog(state, `${name} joined the colony`);
            }
        }
    }
}

// QuestSystem -- colonists perform real-life quests from the Quest app
const QUEST_SYNC_INTERVAL = 120; // sync every 120 ticks
const QUEST_WORK_TICKS = 60;     // ticks to "complete" a quest in-game

const questBubbles = {
    fitness: ['Hitting the gym', 'Lifting weights', 'Running laps', 'Working out'],
    study: ['Reading books', 'Taking notes', 'Studying hard', 'At the library'],
    work: ['Coding away', 'In the zone', 'Building apps', 'Shipping code'],
    personal: ['Self-care time', 'Getting organized', 'Journaling', 'Meditating'],
    creative: ['Making art', 'Writing music', 'Designing', 'Creating'],
    errand: ['Running errands', 'Getting supplies', 'Out and about', 'On a mission'],
};

export function questTick(state, pathfinder) {
    // Periodic sync from Quest app localStorage
    if (state.currentTick % QUEST_SYNC_INTERVAL === 0) {
        syncQuests(state);
    }

    if (!state.quests.length) return;

    // Find quest board buildings
    const questBuildings = state.buildings.filter(b =>
        ['questBoard', 'gym', 'library', 'workshop'].includes(b.type) && b.isActive
    );
    if (!questBuildings.length) return;

    // Assign idle colonists to quests
    for (const c of state.colonists) {
        if (c.state === 'dead') continue;

        // Already on a quest -- tick it down
        if (c.activeQuest) {
            c.activeQuest.ticksRemaining--;
            if (c.activeQuest.ticksRemaining <= 0) {
                // Quest complete in-game
                grantXP(c, c.activeQuest.xp);
                c.questBubble = { text: `Done: ${c.activeQuest.title}`, ticks: 30 };
                gameLog(state, `${c.name} completed quest: ${c.activeQuest.title}`);
                state.questLog.push({ colonist: c.name, quest: c.activeQuest.title, tick: state.currentTick });
                c.activeQuest = null;
                c.job = 'idle';
            }
            continue;
        }

        // Assign a quest to idle colonists near quest buildings
        if (c.job !== 'idle' || c.jobOverride) continue;

        // Pick a random quest
        const quest = state.quests[Math.floor(Math.random() * state.quests.length)];
        const targetType = QuestBuildings[quest.category] || 'questBoard';
        const target = questBuildings.find(b => b.type === targetType) || questBuildings[0];

        const dist = Math.abs(c.col - target.col) + Math.abs(c.row - target.row);
        if (dist <= 3) {
            // Close enough -- start working on quest
            c.job = 'quest';
            c.activeQuest = { ...quest, ticksRemaining: QUEST_WORK_TICKS };
            const bubbles = questBubbles[quest.category] || questBubbles.personal;
            c.questBubble = { text: bubbles[Math.floor(Math.random() * bubbles.length)], ticks: 40 };
        } else {
            // Path to the building
            const path = pathfinder.findPath(c.col, c.row, target.col, target.row);
            if (path.length) {
                c.job = 'quest';
                c.pathCols = path.map(p => p.col);
                c.pathRows = path.map(p => p.row);
                c.pathIndex = 0;
                c.activeQuest = { ...quest, ticksRemaining: QUEST_WORK_TICKS };
                const bubbles = questBubbles[quest.category] || questBubbles.personal;
                c.questBubble = { text: quest.title, ticks: 30 };
            }
        }
    }

    // Tick down speech bubbles
    for (const c of state.colonists) {
        if (c.questBubble) {
            c.questBubble.ticks--;
            if (c.questBubble.ticks <= 0) c.questBubble = null;
        }
    }
}

function tickCombat(i, state, pathfinder) {
    const attacker = state.colonists[i];
    if (!attacker.attackTargetId) { attacker.job = 'idle'; return; }
    const targetIdx = state.colonists.findIndex(c => c.id === attacker.attackTargetId);
    if (targetIdx === -1) { attacker.job = 'idle'; attacker.attackTargetId = null; return; }

    const target = state.colonists[targetIdx];
    if (target.state === 'dead') {
        attacker.job = 'idle';
        attacker.attackTargetId = null;
        grantXP(attacker, 15);
        gameLog(state, `${attacker.name} killed ${target.name}`);
        return;
    }

    const dist = Math.abs(attacker.col - target.col) + Math.abs(attacker.row - target.row);
    const weapon = WeaponTypes[attacker.weapon];

    if (dist <= weapon.range) {
        const dmg = weapon.damage * (1.0 + attacker.stats.str * 0.1);
        takeDamage(target, dmg);
        grantXP(attacker, 2);
    } else if (attacker.pathIndex >= attacker.pathCols.length) {
        const path = pathfinder.findPath(attacker.col, attacker.row, target.col, target.row);
        if (path.length) {
            attacker.pathCols = path.map(p => p.col);
            attacker.pathRows = path.map(p => p.row);
            attacker.pathIndex = 0;
        }
    }
}
