// Canvas renderer -- tiles, entities, selection, health bars, minimap

import { TILE_SIZE, TileColors, GRID_SIZE } from './world.js';
import { BuildingType, WeaponTypes, ResourceSymbol } from './state.js';

const COLONIST_SIZE = 12;

const STATE_COLORS = {
    healthy: '#30d158',
    hungry: '#ffd60a',
    suffocating: '#64d2ff',
    exhausted: '#ff9f0a',
    dead: '#666',
};

const RESOURCE_COLORS = {
    food: '#30d158',
    power: '#ffd60a',
    materials: '#ff9f0a',
    oxygen: '#64d2ff',
    cash: '#ff375f',
};

const BUILDING_COLORS = {
    shelter: '#2a4a5a',
    foodStall: '#3a6a3a',
    generator: '#5a5a2a',
    filterStation: '#2a3a5a',
    subwayAccess: '#5a4a2a',
    billboard: '#5a2a4a',
};

export function renderWorld(ctx, canvas, camera, grid, state) {
    ctx.save();
    camera.applyTransform(ctx, canvas);

    const bounds = camera.visibleBounds(canvas);

    // Tiles
    for (let r = bounds.minRow; r <= bounds.maxRow; r++) {
        for (let c = bounds.minCol; c <= bounds.maxCol; c++) {
            const tile = grid[r][c];
            ctx.fillStyle = TileColors[tile];
            ctx.fillRect(c * TILE_SIZE, r * TILE_SIZE, TILE_SIZE, TILE_SIZE);
        }
    }

    // Night overlay
    if (state.isNight) {
        ctx.fillStyle = 'rgba(0, 0, 30, 0.3)';
        ctx.fillRect(bounds.minCol * TILE_SIZE, bounds.minRow * TILE_SIZE,
            (bounds.maxCol - bounds.minCol + 1) * TILE_SIZE,
            (bounds.maxRow - bounds.minRow + 1) * TILE_SIZE);
    }

    // Resource nodes
    for (const rn of state.resourceNodes) {
        if (rn.col < bounds.minCol || rn.col > bounds.maxCol || rn.row < bounds.minRow || rn.row > bounds.maxRow) continue;
        const x = rn.col * TILE_SIZE + TILE_SIZE / 2;
        const y = rn.row * TILE_SIZE + TILE_SIZE / 2;
        const alpha = rn.remaining <= 0 ? 0.15 : Math.max(0.3, rn.remaining / rn.maxAmount);
        ctx.globalAlpha = alpha;
        ctx.fillStyle = RESOURCE_COLORS[rn.type];
        ctx.beginPath();
        ctx.arc(x, y, 6, 0, Math.PI * 2);
        ctx.fill();
        ctx.globalAlpha = 1;
        // Symbol
        ctx.fillStyle = '#fff';
        ctx.font = '8px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(ResourceSymbol[rn.type], x, y);
    }

    // Buildings
    for (const b of state.buildings) {
        const bt = BuildingType[b.type];
        const [w, h] = bt.size;
        const bx = b.col * TILE_SIZE;
        const by = b.row * TILE_SIZE;
        if (bx + w * TILE_SIZE < bounds.minCol * TILE_SIZE || bx > (bounds.maxCol + 1) * TILE_SIZE) continue;
        if (by + h * TILE_SIZE < bounds.minRow * TILE_SIZE || by > (bounds.maxRow + 1) * TILE_SIZE) continue;

        ctx.fillStyle = BUILDING_COLORS[b.type] || '#333';
        ctx.fillRect(bx, by, w * TILE_SIZE, h * TILE_SIZE);
        ctx.strokeStyle = 'rgba(0, 245, 212, 0.4)';
        ctx.lineWidth = 1;
        ctx.strokeRect(bx, by, w * TILE_SIZE, h * TILE_SIZE);

        ctx.fillStyle = '#fff';
        ctx.font = 'bold 9px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(bt.name, bx + (w * TILE_SIZE) / 2, by + (h * TILE_SIZE) / 2);
    }

    // Colonists
    for (const c of state.colonists) {
        if (c.col < bounds.minCol - 1 || c.col > bounds.maxCol + 1 || c.row < bounds.minRow - 1 || c.row > bounds.maxRow + 1) continue;
        const x = c.col * TILE_SIZE + TILE_SIZE / 2;
        const y = c.row * TILE_SIZE + TILE_SIZE / 2;

        // Selection ring
        const isSelected = c.id === state.selectedColonistId || state.selectedColonistIds.has(c.id);
        if (isSelected) {
            ctx.strokeStyle = '#ffd60a';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(x, y, COLONIST_SIZE + 4, 0, Math.PI * 2);
            ctx.stroke();
        }

        // Green indicator circle
        ctx.fillStyle = c.state === 'dead' ? 'rgba(100,100,100,0.4)' : 'rgba(122, 242, 120, 0.4)';
        ctx.beginPath();
        ctx.arc(x, y, COLONIST_SIZE, 0, Math.PI * 2);
        ctx.fill();

        // Body
        ctx.fillStyle = STATE_COLORS[c.state];
        ctx.fillRect(x - 5, y - 8, 10, 16);

        // Health bar
        const barW = 24;
        const barH = 3;
        const barX = x - barW / 2;
        const barY = y - COLONIST_SIZE - 6;
        ctx.fillStyle = 'rgba(50,50,50,0.8)';
        ctx.fillRect(barX, barY, barW, barH);
        const hpFrac = Math.max(0, c.health / 100);
        ctx.fillStyle = hpFrac > 0.5 ? '#30d158' : hpFrac > 0.25 ? '#ffd60a' : '#ff375f';
        ctx.fillRect(barX, barY, barW * hpFrac, barH);

        // Name
        ctx.fillStyle = '#fff';
        ctx.font = '8px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(c.name, x, barY - 3);
    }

    // Build ghost
    if (state.inputMode === 'build' && state.selectedBuildingType && state._ghostCol != null) {
        const bt = BuildingType[state.selectedBuildingType];
        const [w, h] = bt.size;
        ctx.fillStyle = 'rgba(255,255,255,0.2)';
        ctx.fillRect(state._ghostCol * TILE_SIZE, state._ghostRow * TILE_SIZE, w * TILE_SIZE, h * TILE_SIZE);
        ctx.strokeStyle = 'rgba(255,255,255,0.5)';
        ctx.lineWidth = 1;
        ctx.strokeRect(state._ghostCol * TILE_SIZE, state._ghostRow * TILE_SIZE, w * TILE_SIZE, h * TILE_SIZE);
    }

    // Selection rectangle
    if (state._selRect) {
        const r = state._selRect;
        ctx.strokeStyle = 'rgba(0, 245, 212, 0.8)';
        ctx.fillStyle = 'rgba(0, 245, 212, 0.1)';
        ctx.lineWidth = 2;
        ctx.fillRect(r.x, r.y, r.w, r.h);
        ctx.strokeRect(r.x, r.y, r.w, r.h);
    }

    ctx.restore();
}

// Minimap
export function renderMinimap(ctx, canvas, grid, state, camera) {
    const mw = canvas.width;
    const mh = canvas.height;
    const scale = mw / (GRID_SIZE * TILE_SIZE);

    ctx.fillStyle = '#0a0a0c';
    ctx.fillRect(0, 0, mw, mh);

    // Tiles (sampled)
    const step = Math.max(1, Math.floor(GRID_SIZE / mw));
    for (let r = 0; r < GRID_SIZE; r += step) {
        for (let c = 0; c < GRID_SIZE; c += step) {
            ctx.fillStyle = TileColors[grid[r][c]];
            const px = (c * TILE_SIZE) * scale;
            const py = (r * TILE_SIZE) * scale;
            const ps = TILE_SIZE * scale * step;
            ctx.fillRect(px, py, Math.max(1, ps), Math.max(1, ps));
        }
    }

    // Colonists
    ctx.fillStyle = '#30d158';
    for (const c of state.colonists) {
        if (c.state === 'dead') continue;
        const px = c.col * TILE_SIZE * scale;
        const py = c.row * TILE_SIZE * scale;
        ctx.fillRect(px - 1, py - 1, 3, 3);
    }

    // Camera viewport
    const bounds = camera.visibleBounds(document.getElementById('game'));
    ctx.strokeStyle = '#ffd60a';
    ctx.lineWidth = 1;
    ctx.strokeRect(
        bounds.minCol * TILE_SIZE * scale,
        bounds.minRow * TILE_SIZE * scale,
        (bounds.maxCol - bounds.minCol) * TILE_SIZE * scale,
        (bounds.maxRow - bounds.minRow) * TILE_SIZE * scale
    );
}
