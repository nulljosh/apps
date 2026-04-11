import { useRef, useEffect, useCallback } from 'react';
import './Canvas.css';
import { pxToCell, stampComponent } from '../lib/engine.js';

const FONT_SIZE = 14;
const FONT_FAMILY = "'Berkeley Mono', 'JetBrains Mono', 'Fira Code', ui-monospace, monospace";
const LINE_HEIGHT = 20;

function measureCharWidth(fontSize, fontFamily) {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  ctx.font = `${fontSize}px ${fontFamily}`;
  return ctx.measureText('M').width;
}

export default function Canvas({
  grid,
  cols,
  rows,
  cursor,
  selectedPreset,
  onPlaceComponent,
  onCursorMove,
  onUndo,
  onRedo,
}) {
  const canvasRef = useRef(null);
  const charWRef = useRef(null);
  const hoverRef = useRef(null);

  // Lazy-measure char width once
  function getCharW() {
    if (!charWRef.current) {
      charWRef.current = measureCharWidth(FONT_SIZE, FONT_FAMILY);
    }
    return charWRef.current;
  }

  // Draw the full grid
  const draw = useCallback((hoverCell) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const charW = getCharW();
    const charH = LINE_HEIGHT;

    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Background
    ctx.fillStyle = '#0c1a12';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Grid dots
    ctx.fillStyle = '#1e3528';
    for (let r = 0; r <= rows; r++) {
      for (let c = 0; c <= cols; c++) {
        ctx.fillRect(Math.round(c * charW), r * charH, 1, 1);
      }
    }

    // Hover preview
    if (hoverCell && selectedPreset) {
      const { col, row } = hoverCell;
      const previewGrid = stampComponent(grid, selectedPreset.template, col, row);
      ctx.font = `${FONT_SIZE}px ${FONT_FAMILY}`;
      ctx.fillStyle = '#3d9e6a55';
      for (let dy = 0; dy < selectedPreset.height; dy++) {
        const r = row + dy;
        if (r < 0 || r >= rows) continue;
        for (let dc = 0; dc < selectedPreset.width; dc++) {
          const c = col + dc;
          if (c < 0 || c >= cols) continue;
          ctx.fillText(previewGrid[r][c], c * charW, r * charH + FONT_SIZE);
        }
      }
    }

    // Characters
    ctx.font = `${FONT_SIZE}px ${FONT_FAMILY}`;
    ctx.fillStyle = '#e8e4da';
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const ch = grid[r][c];
        if (ch !== ' ') {
          ctx.fillText(ch, c * charW, r * charH + FONT_SIZE);
        }
      }
    }

    // Cursor
    const cx = cursor.col * charW;
    const cy = cursor.row * charH;
    ctx.strokeStyle = '#3d9e6a';
    ctx.lineWidth = 1;
    ctx.strokeRect(cx + 0.5, cy + 0.5, charW - 1, charH - 1);
  }, [grid, cols, rows, cursor, selectedPreset]);

  // Resize canvas to match display size
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const charW = getCharW();
    const w = Math.ceil(cols * charW);
    const h = rows * LINE_HEIGHT;
    if (canvas.width !== w || canvas.height !== h) {
      canvas.width = w;
      canvas.height = h;
    }
    draw(hoverRef.current);
  }, [grid, cols, rows, cursor, selectedPreset, draw]);

  const getCellFromEvent = useCallback((e) => {
    const canvas = canvasRef.current;
    const rect = canvas.getBoundingClientRect();
    const charW = getCharW();
    const scaleX = canvas.width / rect.width;
    const scaleY = canvas.height / rect.height;
    const px = (e.clientX - rect.left) * scaleX;
    const py = (e.clientY - rect.top) * scaleY;
    return pxToCell(px, py, charW, LINE_HEIGHT);
  }, []);

  const handleMouseMove = useCallback((e) => {
    const cell = getCellFromEvent(e);
    hoverRef.current = cell;
    onCursorMove(cell.col, cell.row);
    draw(cell);
  }, [getCellFromEvent, onCursorMove, draw]);

  const handleMouseLeave = useCallback(() => {
    hoverRef.current = null;
    draw(null);
  }, [draw]);

  const handleClick = useCallback((e) => {
    const cell = getCellFromEvent(e);
    onCursorMove(cell.col, cell.row);
    if (selectedPreset) {
      onPlaceComponent(selectedPreset, cell.col, cell.row);
    }
  }, [getCellFromEvent, selectedPreset, onPlaceComponent, onCursorMove]);

  const handleKeyDown = useCallback((e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'z') {
      e.preventDefault();
      onUndo();
    }
    if ((e.ctrlKey || e.metaKey) && (e.key === 'y' || (e.shiftKey && e.key === 'z'))) {
      e.preventDefault();
      onRedo();
    }
  }, [onUndo, onRedo]);

  return (
    <div className="canvas-wrapper" onKeyDown={handleKeyDown} tabIndex={0}>
      <div className="canvas-scroll">
        <canvas
          ref={canvasRef}
          className={`canvas${selectedPreset ? ' canvas--place-mode' : ''}`}
          onMouseMove={handleMouseMove}
          onMouseLeave={handleMouseLeave}
          onClick={handleClick}
        />
      </div>
    </div>
  );
}
