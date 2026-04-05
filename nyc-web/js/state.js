// Game state and models -- direct port from Swift

let _nextId = 0;
export function uuid() { return `${++_nextId}-${Math.random().toString(36).slice(2, 8)}`; }

export const ResourceType = { food: 'food', power: 'power', materials: 'materials', oxygen: 'oxygen', cash: 'cash' };
export const ResourceTypes = ['food', 'power', 'materials', 'oxygen', 'cash'];
export const ResourceSymbol = { food: 'F', power: 'P', materials: 'M', oxygen: 'O', cash: '$' };

export const ColonistJob = { idle: 'idle', gather: 'gather', build: 'build', patrol: 'patrol', attack: 'attack' };
export const ColonistJobs = ['idle', 'gather', 'build', 'patrol', 'attack'];

export const ColonyDirective = { idle: 'idle', gather: 'gather', build: 'build', patrol: 'patrol' };
export const ColonyDirectives = ['idle', 'gather', 'build', 'patrol'];

export const ColonistState = { healthy: 'healthy', hungry: 'hungry', suffocating: 'suffocating', exhausted: 'exhausted', dead: 'dead' };

export const WeaponTypes = {
    fists:   { damage: 5,  range: 1, name: 'FISTS' },
    pipe:    { damage: 10, range: 1, name: 'PIPE' },
    bat:     { damage: 12, range: 1, name: 'BAT' },
    pistol:  { damage: 20, range: 5, name: 'PISTOL' },
    shotgun: { damage: 30, range: 3, name: 'SHOTGUN' },
    rifle:   { damage: 25, range: 8, name: 'RIFLE' },
};

export const Traits = {
    hustler:   { name: 'Hustler',   desc: '+20% XP gain' },
    scavenger: { name: 'Scavenger', desc: '+1 resource per harvest' },
    insomniac: { name: 'Insomniac', desc: '30% slower sleep decay' },
    ironlung:  { name: 'Ironlung',  desc: '30% slower oxygen decay' },
    anxious:   { name: 'Anxious',   desc: '2x stress gain' },
};
export const TraitKeys = Object.keys(Traits);

export const BuildingType = {
    shelter:       { name: 'Shelter',        cost: { materials: 10 },              desc: 'Reduces stress for nearby colonists',   size: [2,2] },
    foodStall:     { name: 'Food Stall',     cost: { materials: 8, cash: 5 },      desc: 'Converts food resources into meals',    size: [1,1] },
    generator:     { name: 'Generator',      cost: { materials: 15, cash: 10 },    desc: 'Produces power from materials',         size: [2,2] },
    filterStation: { name: 'Filter Station', cost: { materials: 12, power: 5 },    desc: 'Filters oxygen using power',            size: [2,2] },
    subwayAccess:  { name: 'Subway Access',  cost: { materials: 20, cash: 15 },    desc: 'Fast travel between subway stations',   size: [1,1] },
    billboard:     { name: 'Billboard',      cost: { materials: 5, cash: 20 },     desc: 'Generates cash over time',              size: [2,1] },
};
export const BuildingTypes = Object.keys(BuildingType);

export const InputMode = { normal: 'normal', build: 'build', demolish: 'demolish' };

function randInt(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
function randomStats() { return { str: randInt(1,10), int: randInt(1,10), agi: randInt(1,10), end: randInt(1,10), cha: randInt(1,10) }; }
function randomTrait() { return TraitKeys[randInt(0, TraitKeys.length - 1)]; }

export function createColonist(name, col, row) {
    return {
        id: uuid(), name, col, row,
        hunger: 100, oxygen: 100, stress: 0, sleep: 100, health: 100,
        job: 'idle', jobOverride: false, state: 'healthy',
        weapon: 'fists', attackTargetId: null,
        inventory: {},
        pathCols: [], pathRows: [], pathIndex: 0,
        stats: randomStats(), xp: 0, level: 1,
        trait: randomTrait(),
    };
}

export function colonistXpForNext(c) { return Math.max(100, c.level * 100); }
export function colonistXpProgress(c) { return c.xp / colonistXpForNext(c); }
export function colonistMovementSpeed(c) { return 1.0 + c.stats.agi * 0.1; }
export function colonistHungerDecay(c) { return 1.0 - c.stats.end * 0.05; }
export function colonistBuildDiscount(c) { return c.stats.int * 0.02; }

export function grantXP(c, amount) {
    const adjusted = c.trait === 'hustler' ? Math.floor(amount * 1.2) : amount;
    c.xp += adjusted;
    let next = colonistXpForNext(c);
    while (c.xp >= next) {
        c.xp -= next;
        c.level++;
        // Boost random stat
        const stats = ['str','int','agi','end','cha'];
        const s = stats[randInt(0,4)];
        c.stats[s] = Math.min(10, c.stats[s] + 1);
        next = colonistXpForNext(c);
    }
}

export function takeDamage(c, amount) {
    c.health = Math.max(0, c.health - amount);
    if (c.health <= 0) c.state = 'dead';
}

export function updateColonistState(c) {
    if (c.state === 'dead') return;
    if (c.health <= 0 || c.hunger <= 0 || c.oxygen <= 0 || c.sleep <= 0) { c.state = 'dead'; return; }
    if (c.hunger < 20) c.state = 'hungry';
    else if (c.oxygen < 20) c.state = 'suffocating';
    else if (c.sleep < 20) c.state = 'exhausted';
    else c.state = 'healthy';
}

export function createBuilding(type, col, row) {
    return { id: uuid(), type, col, row, isActive: true };
}

export function createResource(type, col, row, maxAmount) {
    return { id: uuid(), type, col, row, remaining: maxAmount, maxAmount, respawnTicks: 60, ticksSinceDepleted: 0 };
}

export function createGameState() {
    return {
        resources: { food: 20, power: 10, materials: 30, oxygen: 50, cash: 25 },
        colonists: [],
        buildings: [],
        resourceNodes: [],
        selectedColonistId: null,
        selectedColonistIds: new Set(),
        isPaused: false,
        currentTick: 0,
        currentHour: 0,
        isNight: false,
        inputMode: 'normal',
        selectedBuildingType: null,
        gameLog: [],
        showBuildMenu: false,
        showSettings: false,
        currentDirective: 'idle',
        tutorialStep: 0,
        lastSaveSlot: null,
        autoSaveEnabled: true,
        autoplay: false,
        showSaveIndicator: false,
    };
}

export function gameLog(state, msg) {
    state.gameLog.push(msg);
    if (state.gameLog.length > 50) state.gameLog.shift();
}

export function selectedColonist(state) {
    if (!state.selectedColonistId) return null;
    return state.colonists.find(c => c.id === state.selectedColonistId) || null;
}
