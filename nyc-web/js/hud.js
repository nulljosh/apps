// HUD -- HTML overlay updates

import { ResourceTypes, ResourceSymbol, BuildingType, BuildingTypes, ColonistJobs, ColonyDirectives, Traits, WeaponTypes, selectedColonist, colonistXpForNext, colonistXpProgress } from './state.js';
import { listSlots } from './save.js';

const RES_COLORS = { food: '#30d158', power: '#ffd60a', materials: '#ff9f0a', oxygen: '#64d2ff', cash: '#ff375f' };
const STATE_COLORS = { healthy: '#30d158', hungry: '#ffd60a', suffocating: '#64d2ff', exhausted: '#ff9f0a', dead: '#666' };

export function updateHUD(state, callbacks) {
    updateResourceBar(state);
    updateBuildMenu(state, callbacks);
    updateColonistPanel(state, callbacks);
    updateDirectiveBar(state, callbacks);
    updateGameLog(state);
    updateTimeDisplay(state);
    updatePauseOverlay(state);
    updateSaveIndicator(state);
    updateSettings(state, callbacks);
    updateTutorial(state, callbacks);
}

function updateResourceBar(state) {
    const resBar = document.getElementById('resource-bar');
    resBar.textContent = '';
    for (const t of ResourceTypes) {
        const span = document.createElement('span');
        span.className = 'res-item';
        const sym = document.createElement('span');
        sym.style.cssText = `color:${RES_COLORS[t]};font-weight:bold`;
        sym.textContent = ResourceSymbol[t];
        span.appendChild(sym);
        span.appendChild(document.createTextNode(` ${state.resources[t] || 0}`));
        resBar.appendChild(span);
    }
    const alive = document.createElement('span');
    alive.className = 'res-item';
    alive.style.cssText = 'margin-left:auto;font-weight:bold';
    alive.textContent = `${state.colonists.filter(c => c.state !== 'dead').length} alive`;
    resBar.appendChild(alive);
}

function updateBuildMenu(state, callbacks) {
    const buildMenu = document.getElementById('build-menu');
    if (!state.showBuildMenu) { buildMenu.style.display = 'none'; return; }
    buildMenu.style.display = 'block';
    buildMenu.textContent = '';

    const title = document.createElement('div');
    title.className = 'hud-title hud-yellow';
    title.textContent = 'BUILD';
    buildMenu.appendChild(title);

    BuildingTypes.forEach((key, i) => {
        const bt = BuildingType[key];
        const sel = state.selectedBuildingType === key;
        const btn = document.createElement('button');
        btn.className = 'build-btn' + (sel ? ' selected' : '');

        const num = document.createElement('span');
        num.className = 'hud-pink';
        num.textContent = `${i + 1}. `;
        btn.appendChild(num);
        btn.appendChild(document.createTextNode(bt.name + ' '));

        const cost = document.createElement('span');
        cost.className = 'cost';
        cost.textContent = Object.entries(bt.cost).map(([r, a]) => `${ResourceSymbol[r]}${a}`).join(' ');
        btn.appendChild(cost);

        btn.onclick = () => {
            state.selectedBuildingType = key;
            state.inputMode = 'build';
            callbacks.onHudUpdate();
        };
        buildMenu.appendChild(btn);
    });

    buildMenu.appendChild(document.createElement('hr'));

    const demBtn = document.createElement('button');
    demBtn.className = 'build-btn demolish-btn' + (state.inputMode === 'demolish' ? ' selected' : '');
    demBtn.textContent = 'X. DEMOLISH';
    demBtn.onclick = () => { state.inputMode = 'demolish'; callbacks.onHudUpdate(); };
    buildMenu.appendChild(demBtn);
}

function updateColonistPanel(state, callbacks) {
    const panel = document.getElementById('colonist-panel');
    const col = selectedColonist(state);
    if (!col) { panel.style.display = 'none'; return; }
    panel.style.display = 'block';
    panel.textContent = '';

    const trait = Traits[col.trait];
    const weapon = WeaponTypes[col.weapon];

    // Header
    const header = document.createElement('div');
    header.className = 'panel-header';
    const nameEl = document.createElement('span');
    nameEl.className = 'hud-panel-name';
    nameEl.textContent = col.name;
    const lvl = document.createElement('span');
    lvl.className = 'hud-panel-level';
    lvl.textContent = `Lv.${col.level}`;
    header.appendChild(nameEl);
    header.appendChild(lvl);
    panel.appendChild(header);

    // State
    const stateEl = document.createElement('div');
    stateEl.style.cssText = `color:${STATE_COLORS[col.state]};font-size:11px`;
    stateEl.textContent = col.state.toUpperCase();
    panel.appendChild(stateEl);

    // Trait
    const traitEl = document.createElement('div');
    traitEl.className = 'trait-badge';
    traitEl.textContent = `${trait.name.toUpperCase()} ${trait.desc}`;
    panel.appendChild(traitEl);

    panel.appendChild(createHR());

    // Need bars
    panel.appendChild(createNeedBar('HP', col.health, '#ff453a'));
    panel.appendChild(createNeedBar('HNG', col.hunger, '#30d158'));
    panel.appendChild(createNeedBar('O2', col.oxygen, '#64d2ff'));
    panel.appendChild(createNeedBar('STS', 100 - col.stress, '#ff375f'));
    panel.appendChild(createNeedBar('SLP', col.sleep, '#0071e3'));

    panel.appendChild(createHR());

    // Stats header
    const statsTitle = document.createElement('div');
    statsTitle.style.cssText = 'font-size:10px;color:rgba(255,255,255,0.6);font-weight:bold';
    statsTitle.textContent = 'STATS';
    panel.appendChild(statsTitle);

    panel.appendChild(createStatBar('STR', col.stats.str));
    panel.appendChild(createStatBar('INT', col.stats.int));
    panel.appendChild(createStatBar('AGI', col.stats.agi));
    panel.appendChild(createStatBar('END', col.stats.end));
    panel.appendChild(createStatBar('CHA', col.stats.cha));
    panel.appendChild(createXPBar(col));

    panel.appendChild(createHR());

    // Job
    const jobLabel = document.createElement('div');
    jobLabel.style.cssText = 'font-size:10px;color:rgba(255,255,255,0.6);font-weight:bold';
    jobLabel.textContent = `JOB: ${col.job.toUpperCase()}`;
    panel.appendChild(jobLabel);

    const jobBtns = document.createElement('div');
    jobBtns.className = 'job-buttons';
    ColonistJobs.forEach(job => {
        const btn = document.createElement('button');
        btn.className = 'job-btn' + (col.job === job ? ' active' : '');
        btn.textContent = job.slice(0, 4).toUpperCase();
        btn.onclick = () => {
            const idx = state.colonists.findIndex(c => c.id === state.selectedColonistId);
            if (idx >= 0) { state.colonists[idx].job = job; callbacks.onHudUpdate(); }
        };
        jobBtns.appendChild(btn);
    });
    panel.appendChild(jobBtns);

    panel.appendChild(createHR());

    // Weapon
    const weaponEl = document.createElement('div');
    weaponEl.style.fontSize = '10px';
    weaponEl.textContent = `WEAPON: ${weapon.name}  DMG:${Math.floor(weapon.damage)} RNG:${weapon.range}`;
    panel.appendChild(weaponEl);

    // Position
    const posEl = document.createElement('div');
    posEl.style.cssText = 'font-size:10px;color:rgba(255,255,255,0.4)';
    posEl.textContent = `Pos: (${col.col}, ${col.row})`;
    panel.appendChild(posEl);
}

function createHR() {
    return document.createElement('hr');
}

function createNeedBar(label, value, color) {
    const row = document.createElement('div');
    row.className = 'need-row';
    const lbl = document.createElement('span');
    lbl.className = 'need-label';
    lbl.textContent = label;
    const bg = document.createElement('div');
    bg.className = 'bar-bg';
    const fill = document.createElement('div');
    fill.className = 'bar-fill';
    fill.style.transform = `scaleX(${Math.max(0, Math.min(100, value)) / 100})`;
    fill.style.background = color;
    bg.appendChild(fill);
    const val = document.createElement('span');
    val.className = 'need-val';
    val.textContent = Math.floor(value);
    row.appendChild(lbl);
    row.appendChild(bg);
    row.appendChild(val);
    return row;
}

function createStatBar(label, value) {
    const row = document.createElement('div');
    row.className = 'need-row';
    const lbl = document.createElement('span');
    lbl.className = 'need-label';
    lbl.textContent = label;
    const dots = document.createElement('div');
    dots.className = 'stat-dots';
    for (let i = 0; i < 10; i++) {
        const dot = document.createElement('span');
        dot.className = 'stat-dot' + (i < value ? ' filled' : '');
        dots.appendChild(dot);
    }
    const val = document.createElement('span');
    val.className = 'need-val';
    val.textContent = value;
    row.appendChild(lbl);
    row.appendChild(dots);
    row.appendChild(val);
    return row;
}

function createXPBar(c) {
    const pct = colonistXpProgress(c) * 100;
    const row = document.createElement('div');
    row.className = 'need-row';
    const lbl = document.createElement('span');
    lbl.className = 'need-label';
    lbl.textContent = 'XP';
    const bg = document.createElement('div');
    bg.className = 'bar-bg';
    const fill = document.createElement('div');
    fill.className = 'bar-fill';
    fill.style.transform = `scaleX(${pct / 100})`;
    fill.style.background = '#ffd60a';
    bg.appendChild(fill);
    const val = document.createElement('span');
    val.className = 'need-val';
    val.style.width = '50px';
    val.textContent = `${c.xp}/${colonistXpForNext(c)}`;
    row.appendChild(lbl);
    row.appendChild(bg);
    row.appendChild(val);
    return row;
}

function updateDirectiveBar(state, callbacks) {
    const dirBar = document.getElementById('directive-bar');
    dirBar.textContent = '';
    const label = document.createElement('span');
    label.style.cssText = 'font-size:10px;font-weight:bold;color:rgba(255,255,255,0.6)';
    label.textContent = 'DIRECTIVE:';
    dirBar.appendChild(label);
    ColonyDirectives.forEach(d => {
        const btn = document.createElement('button');
        btn.className = 'dir-btn' + (state.currentDirective === d ? ' active' : '');
        btn.textContent = d.toUpperCase();
        btn.onclick = () => { state.currentDirective = d; callbacks.onHudUpdate(); };
        dirBar.appendChild(btn);
    });
}

function updateGameLog(state) {
    const logEl = document.getElementById('game-log');
    logEl.textContent = '';
    state.gameLog.slice(-5).forEach(m => {
        const div = document.createElement('div');
        div.textContent = m;
        logEl.appendChild(div);
    });
}

function updateTimeDisplay(state) {
    document.getElementById('time-display').textContent = `Tick ${state.currentTick} | ${state.currentHour}:00 | ${state.isNight ? 'NIGHT' : 'DAY'}`;
}

function updatePauseOverlay(state) {
    document.getElementById('pause-overlay').style.display = state.isPaused && !state.showSettings ? 'flex' : 'none';
}

function updateSaveIndicator(state) {
    document.getElementById('save-indicator').style.display = state.showSaveIndicator ? 'block' : 'none';
}

function updateSettings(state, callbacks) {
    const el = document.getElementById('settings-overlay');
    if (!state.showSettings) { el.style.display = 'none'; return; }
    el.style.display = 'flex';
    el.textContent = '';

    const panel = document.createElement('div');
    panel.className = 'settings-panel';
    panel.onclick = e => e.stopPropagation();

    // Title
    const title = document.createElement('div');
    title.className = 'hud-big-title';
    title.textContent = 'SETTINGS';
    panel.appendChild(title);
    panel.appendChild(createHR());

    // Controls
    const ctrlTitle = document.createElement('div');
    ctrlTitle.className = 'hud-section-title';
    ctrlTitle.textContent = 'CONTROLS';
    panel.appendChild(ctrlTitle);

    const controls = [
        ['WASD / Arrows', 'Pan camera'], ['Scroll / Pinch', 'Zoom in/out'], ['Right-drag', 'Pan camera'],
        ['B', 'Toggle build menu'], ['1-6', 'Select building type'], ['X', 'Toggle demolish mode'],
        ['Space', 'Pause/resume'], ['Ctrl+S', 'Save game'], ['Esc', 'Settings / cancel'],
        ['Shift+drag', 'Box select colonists'],
    ];
    controls.forEach(([key, action]) => {
        const row = document.createElement('div');
        row.className = 'ctrl-row';
        const k = document.createElement('span');
        k.className = 'ctrl-key';
        k.textContent = key;
        const a = document.createElement('span');
        a.textContent = action;
        row.appendChild(k);
        row.appendChild(a);
        panel.appendChild(row);
    });

    panel.appendChild(createHR());

    // Save/load
    const saveTitle = document.createElement('div');
    saveTitle.className = 'hud-section-title';
    saveTitle.textContent = 'SAVE / LOAD';
    panel.appendChild(saveTitle);

    const slots = listSlots();
    for (let i = 0; i < 3; i++) {
        const s = slots[i];
        const row = document.createElement('div');
        row.className = 'save-row';
        const label = document.createElement('span');
        label.style.cssText = s ? 'color:#fff;font-size:12px' : 'color:rgba(255,255,255,0.4);font-size:12px';
        label.textContent = s ? `Slot ${i + 1} -- Day ${s.dayCount}` : `Slot ${i + 1} -- Empty`;
        const btn = document.createElement('button');
        btn.className = 'save-btn';
        btn.textContent = 'SAVE';
        const slot = i + 1;
        btn.onclick = e => { e.stopPropagation(); callbacks.onSaveSlot(slot); };
        row.appendChild(label);
        row.appendChild(btn);
        panel.appendChild(row);
    }

    panel.appendChild(createHR());

    const hint = document.createElement('div');
    hint.style.cssText = 'font-size:11px;color:rgba(255,255,255,0.4)';
    hint.textContent = 'Press ESC to close';
    panel.appendChild(hint);

    el.appendChild(panel);
    el.onclick = () => { state.showSettings = false; state.isPaused = false; callbacks.onHudUpdate(); };
}

function updateTutorial(state, callbacks) {
    const el = document.getElementById('tutorial-overlay');
    if (state.tutorialStep === null || state.tutorialStep === undefined) { el.style.display = 'none'; return; }
    el.style.display = 'flex';
    el.textContent = '';

    const steps = [
        { title: 'WELCOME', body: 'Welcome to Times Square. You control a group of survivors.', hint: 'Click to continue' },
        { title: 'NEEDS', body: 'Your colonists have NEEDS -- hunger, oxygen, stress, sleep, health. Keep them alive.', hint: 'Click to continue' },
        { title: 'STATS', body: 'Each colonist has RPG STATS -- STR, INT, AGI, END, CHA. Click one of the small figures walking around.', hint: 'Click a colonist' },
        { title: 'CAMERA', body: 'WASD to pan the camera. Scroll to zoom.', hint: 'Click to continue' },
        { title: 'BUILD', body: 'Press B to open the BUILD menu. Buildings keep your colony running.', hint: 'Press B' },
        { title: 'SHELTER', body: 'Place a SHELTER to reduce stress and let colonists sleep.', hint: 'Place a shelter' },
        { title: 'DIRECTIVES', body: 'Set a DIRECTIVE to auto-assign colonists. Try GATHER to start collecting resources.', hint: 'Click to continue' },
        { title: 'COMBAT', body: 'Colonists carry weapons. Assign ATTACK jobs to fight enemies. STR boosts damage.', hint: 'Click to continue' },
        { title: 'GOOD LUCK', body: 'Press SPACE to pause. Ctrl+S to save. Shift+drag to select multiple colonists. Good luck.', hint: 'Click to dismiss' },
    ];

    const step = state.tutorialStep;
    const data = steps[step] || steps[0];

    const panel = document.createElement('div');
    panel.className = 'tutorial-panel';

    const header = document.createElement('div');
    header.className = 'tut-header';
    const counter = document.createElement('span');
    counter.className = 'hud-muted-sm';
    counter.textContent = `TUTORIAL ${step + 1}/9`;
    const skip = document.createElement('button');
    skip.className = 'tut-skip';
    skip.textContent = 'SKIP';
    skip.onclick = e => { e.stopPropagation(); state.tutorialStep = null; callbacks.onHudUpdate(); };
    header.appendChild(counter);
    header.appendChild(skip);
    panel.appendChild(header);

    const titleEl = document.createElement('div');
    titleEl.className = 'hud-big-title';
    titleEl.style.fontSize = '24px';
    titleEl.textContent = data.title;
    panel.appendChild(titleEl);

    const bodyEl = document.createElement('div');
    bodyEl.style.cssText = 'font-size:14px;color:#fff;text-align:center';
    bodyEl.textContent = data.body;
    panel.appendChild(bodyEl);

    const hintEl = document.createElement('div');
    hintEl.className = 'tut-hint';
    hintEl.textContent = data.hint;
    panel.appendChild(hintEl);

    const dots = document.createElement('div');
    dots.className = 'tut-dots';
    for (let i = 0; i < 9; i++) {
        const dot = document.createElement('span');
        dot.className = 'tut-dot' + (i <= step ? ' active' : '');
        dots.appendChild(dot);
    }
    panel.appendChild(dots);

    panel.onclick = () => {
        if (step >= 8) state.tutorialStep = null;
        else state.tutorialStep = step + 1;
        callbacks.onHudUpdate();
    };

    el.appendChild(panel);
    el.onclick = e => {
        if (e.target === el) {
            if (step >= 8) state.tutorialStep = null;
            else state.tutorialStep = step + 1;
            callbacks.onHudUpdate();
        }
    };
}

export function checkTutorialAdvance(state, event) {
    if (state.tutorialStep === null || state.tutorialStep === undefined) return;
    const step = state.tutorialStep;
    if (step === 2 && event === 'colonistSelected') state.tutorialStep = 3;
    else if (step === 3 && event === 'wasdPressed') state.tutorialStep = 4;
    else if (step === 4 && event === 'buildMenuOpened') state.tutorialStep = 5;
    else if (step === 5 && event === 'shelterPlaced') state.tutorialStep = 6;
}
