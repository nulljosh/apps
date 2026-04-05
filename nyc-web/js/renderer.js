// Canvas renderer -- tiles, entities, selection, health bars, minimap

import { TILE_SIZE, TileColors, GRID_SIZE } from './world.js';
import { BuildingType, ResourceSymbol } from './state.js';

const COLONIST_SIZE = 10;
const GAP = 1;
const TILE_R = 4;

const STATE_COLORS = {
    healthy: '#30d158',
    hungry: '#ffd60a',
    suffocating: '#64d2ff',
    exhausted: '#ff9f0a',
    dead: '#48484a',
};

const RESOURCE_COLORS = {
    food: '#30d158',
    power: '#ffd60a',
    materials: '#ff9f0a',
    oxygen: '#64d2ff',
    cash: '#ff375f',
};

const BUILDING_COLORS = {
    shelter: 'rgba(41, 151, 255, 0.25)',
    foodStall: 'rgba(48, 209, 88, 0.25)',
    generator: 'rgba(255, 214, 10, 0.25)',
    filterStation: 'rgba(100, 210, 255, 0.25)',
    subwayAccess: 'rgba(255, 159, 10, 0.25)',
    billboard: 'rgba(255, 55, 95, 0.25)',
    questBoard: 'rgba(201, 168, 76, 0.3)',
    gym: 'rgba(192, 57, 43, 0.25)',
    library: 'rgba(45, 74, 43, 0.25)',
    workshop: 'rgba(139, 105, 20, 0.25)',
};

const BUILDING_BORDER = {
    shelter: 'rgba(41, 151, 255, 0.5)',
    foodStall: 'rgba(48, 209, 88, 0.5)',
    generator: 'rgba(255, 214, 10, 0.5)',
    filterStation: 'rgba(100, 210, 255, 0.5)',
    subwayAccess: 'rgba(255, 159, 10, 0.5)',
    billboard: 'rgba(255, 55, 95, 0.5)',
    questBoard: 'rgba(201, 168, 76, 0.6)',
    gym: 'rgba(192, 57, 43, 0.5)',
    library: 'rgba(45, 74, 43, 0.5)',
    workshop: 'rgba(139, 105, 20, 0.5)',
};

function roundRect(ctx, x, y, w, h, r) {
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.lineTo(x + w - r, y);
    ctx.quadraticCurveTo(x + w, y, x + w, y + r);
    ctx.lineTo(x + w, y + h - r);
    ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
    ctx.lineTo(x + r, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - r);
    ctx.lineTo(x, y + r);
    ctx.quadraticCurveTo(x, y, x + r, y);
    ctx.closePath();
}

// Pre-rendered tile sprites for performance
const tileSprites = {};
function getTileSprite(tileType) {
    if (tileSprites[tileType]) return tileSprites[tileType];
    const size = TILE_SIZE;
    const c = document.createElement('canvas');
    c.width = size;
    c.height = size;
    const cx = c.getContext('2d');
    cx.fillStyle = TileColors[tileType] || '#0a0a0c';
    roundRect(cx, GAP, GAP, size - GAP * 2, size - GAP * 2, TILE_R);
    cx.fill();
    tileSprites[tileType] = c;
    return c;
}

export function renderWorld(ctx, canvas, camera, grid, state) {
    ctx.save();
    camera.applyTransform(ctx, canvas);

    const bounds = camera.visibleBounds(canvas);

    // Tiles (sprite-cached rounded rects)
    for (let r = bounds.minRow; r <= bounds.maxRow; r++) {
        for (let c = bounds.minCol; c <= bounds.maxCol; c++) {
            ctx.drawImage(getTileSprite(grid[r][c]), c * TILE_SIZE, r * TILE_SIZE);
        }
    }

    // Night overlay
    if (state.isNight) {
        ctx.fillStyle = 'rgba(0, 0, 20, 0.25)';
        ctx.fillRect(bounds.minCol * TILE_SIZE, bounds.minRow * TILE_SIZE,
            (bounds.maxCol - bounds.minCol + 1) * TILE_SIZE,
            (bounds.maxRow - bounds.minRow + 1) * TILE_SIZE);
    }

    // Resource nodes
    for (const rn of state.resourceNodes) {
        if (rn.col < bounds.minCol || rn.col > bounds.maxCol || rn.row < bounds.minRow || rn.row > bounds.maxRow) continue;
        const x = rn.col * TILE_SIZE + TILE_SIZE / 2;
        const y = rn.row * TILE_SIZE + TILE_SIZE / 2;
        const alpha = rn.remaining <= 0 ? 0.12 : Math.max(0.3, rn.maxAmount > 0 ? rn.remaining / rn.maxAmount : 0);

        // Soft glow
        ctx.globalAlpha = alpha * 0.3;
        ctx.fillStyle = RESOURCE_COLORS[rn.type] || '#fff';
        ctx.beginPath();
        ctx.arc(x, y, 10, 0, Math.PI * 2);
        ctx.fill();

        // Core dot
        ctx.globalAlpha = alpha;
        ctx.beginPath();
        ctx.arc(x, y, 5, 0, Math.PI * 2);
        ctx.fill();
        ctx.globalAlpha = 1;

        // Symbol
        ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
        ctx.font = '7px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(ResourceSymbol[rn.type] || '', x, y);
    }

    // Buildings -- glass style
    for (const b of state.buildings) {
        const bt = BuildingType[b.type];
        if (!bt) continue;
        const [w, h] = bt.size;
        const bx = b.col * TILE_SIZE + GAP;
        const by = b.row * TILE_SIZE + GAP;
        const bw = w * TILE_SIZE - GAP * 2;
        const bh = h * TILE_SIZE - GAP * 2;
        if (bx + bw < bounds.minCol * TILE_SIZE || bx > (bounds.maxCol + 1) * TILE_SIZE) continue;
        if (by + bh < bounds.minRow * TILE_SIZE || by > (bounds.maxRow + 1) * TILE_SIZE) continue;

        ctx.fillStyle = BUILDING_COLORS[b.type] || 'rgba(255,255,255,0.1)';
        roundRect(ctx, bx, by, bw, bh, TILE_R + 2);
        ctx.fill();

        ctx.strokeStyle = BUILDING_BORDER[b.type] || 'rgba(255,255,255,0.2)';
        ctx.lineWidth = 1;
        roundRect(ctx, bx, by, bw, bh, TILE_R + 2);
        ctx.stroke();

        ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
        ctx.font = '600 8px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(bt.name, b.col * TILE_SIZE + (w * TILE_SIZE) / 2, b.row * TILE_SIZE + (h * TILE_SIZE) / 2);
    }

    // Colonists
    for (const c of state.colonists) {
        if (c.col < bounds.minCol - 1 || c.col > bounds.maxCol + 1 || c.row < bounds.minRow - 1 || c.row > bounds.maxRow + 1) continue;
        const x = c.col * TILE_SIZE + TILE_SIZE / 2;
        const y = c.row * TILE_SIZE + TILE_SIZE / 2;
        const color = STATE_COLORS[c.state] || '#666';

        // Selection ring
        const isSelected = c.id === state.selectedColonistId || (state.selectedColonistIds && state.selectedColonistIds.has(c.id));
        if (isSelected) {
            ctx.strokeStyle = 'rgba(255, 214, 10, 0.7)';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(x, y, COLONIST_SIZE + 5, 0, Math.PI * 2);
            ctx.stroke();
        }

        // Outer glow
        ctx.globalAlpha = c.state === 'dead' ? 0.15 : 0.2;
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.arc(x, y, COLONIST_SIZE + 2, 0, Math.PI * 2);
        ctx.fill();
        ctx.globalAlpha = 1;

        // Body -- rounded pill shape
        ctx.fillStyle = color;
        roundRect(ctx, x - 5, y - 7, 10, 14, 4);
        ctx.fill();

        // Head
        ctx.beginPath();
        ctx.arc(x, y - 10, 4, 0, Math.PI * 2);
        ctx.fill();

        // Health bar
        const barW = 22;
        const barH = 2;
        const barX = x - barW / 2;
        const barY = y - COLONIST_SIZE - 10;
        ctx.fillStyle = 'rgba(255, 255, 255, 0.1)';
        roundRect(ctx, barX, barY, barW, barH, 1);
        ctx.fill();
        const hpFrac = Math.max(0, c.health / 100);
        ctx.fillStyle = hpFrac > 0.5 ? '#30d158' : hpFrac > 0.25 ? '#ffd60a' : '#ff375f';
        if (hpFrac > 0) {
            roundRect(ctx, barX, barY, barW * hpFrac, barH, 1);
            ctx.fill();
        }

        // Name
        ctx.fillStyle = 'rgba(255, 255, 255, 0.85)';
        ctx.font = '600 7px -apple-system, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(c.name, x, barY - 4);

        // Quest speech bubble
        if (c.questBubble) {
            const bubbleY = barY - 22;
            const text = c.questBubble.text;
            ctx.font = '500 6px -apple-system, sans-serif';
            const tw = ctx.measureText(text).width + 8;
            const bx = x - tw / 2;
            ctx.fillStyle = 'rgba(244, 228, 193, 0.9)';
            roundRect(ctx, bx, bubbleY - 8, tw, 11, 3);
            ctx.fill();
            ctx.fillStyle = '#1c1208';
            ctx.fillText(text, x, bubbleY);
            // tiny triangle pointer
            ctx.beginPath();
            ctx.moveTo(x - 3, bubbleY + 3);
            ctx.lineTo(x + 3, bubbleY + 3);
            ctx.lineTo(x, bubbleY + 7);
            ctx.closePath();
            ctx.fillStyle = 'rgba(244, 228, 193, 0.9)';
            ctx.fill();
        }
    }

    // Build ghost
    if (state.inputMode === 'build' && state.selectedBuildingType && state._ghostCol != null) {
        const bt = BuildingType[state.selectedBuildingType];
        if (bt) {
            const [w, h] = bt.size;
            const gx = state._ghostCol * TILE_SIZE + GAP;
            const gy = state._ghostRow * TILE_SIZE + GAP;
            ctx.fillStyle = 'rgba(41, 151, 255, 0.15)';
            roundRect(ctx, gx, gy, w * TILE_SIZE - GAP * 2, h * TILE_SIZE - GAP * 2, TILE_R + 2);
            ctx.fill();
            ctx.strokeStyle = 'rgba(41, 151, 255, 0.5)';
            ctx.lineWidth = 1;
            roundRect(ctx, gx, gy, w * TILE_SIZE - GAP * 2, h * TILE_SIZE - GAP * 2, TILE_R + 2);
            ctx.stroke();
        }
    }

    // Selection rectangle
    if (state._selRect) {
        const r = state._selRect;
        ctx.strokeStyle = 'rgba(41, 151, 255, 0.6)';
        ctx.fillStyle = 'rgba(41, 151, 255, 0.08)';
        ctx.lineWidth = 2;
        roundRect(ctx, r.x, r.y, r.w, r.h, 4);
        ctx.fill();
        roundRect(ctx, r.x, r.y, r.w, r.h, 4);
        ctx.stroke();
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

    const step = Math.max(1, Math.floor(GRID_SIZE / mw));
    for (let r = 0; r < GRID_SIZE; r += step) {
        if (!grid[r]) continue;
        for (let c = 0; c < GRID_SIZE; c += step) {
            ctx.fillStyle = TileColors[grid[r][c]] || '#0a0a0c';
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
        ctx.beginPath();
        ctx.arc(px, py, 1.5, 0, Math.PI * 2);
        ctx.fill();
    }

    // Camera viewport
    const bounds = camera.visibleBounds(document.getElementById('game'));
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.4)';
    ctx.lineWidth = 1;
    ctx.strokeRect(
        bounds.minCol * TILE_SIZE * scale,
        bounds.minRow * TILE_SIZE * scale,
        (bounds.maxCol - bounds.minCol) * TILE_SIZE * scale,
        (bounds.maxRow - bounds.minRow) * TILE_SIZE * scale
    );
}
