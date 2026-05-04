import { useRef, useEffect, useCallback } from 'react';

const GRID_COLOR = 'rgba(255,255,255,0.06)';
const AXIS_COLOR = 'rgba(255,255,255,0.25)';
const LABEL_COLOR = 'rgba(255,255,255,0.45)';

export default function Graph({ equations }) {
  const canvasRef = useRef(null);
  const transform = useRef({ scale: 60, ox: 0, oy: 0 });
  const drag = useRef(null);

  const draw = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const { width: W, height: H } = canvas;
    const { scale, ox, oy } = transform.current;
    const cx = W / 2 + ox;
    const cy = H / 2 + oy;

    ctx.clearRect(0, 0, W, H);

    // grid
    const step = scale;
    const startX = ((cx % step) - step) % step;
    const startY = ((cy % step) - step) % step;

    ctx.strokeStyle = GRID_COLOR;
    ctx.lineWidth = 1;
    for (let x = startX; x < W; x += step) {
      ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, H); ctx.stroke();
    }
    for (let y = startY; y < H; y += step) {
      ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke();
    }

    // axes
    ctx.strokeStyle = AXIS_COLOR;
    ctx.lineWidth = 1.5;
    ctx.beginPath(); ctx.moveTo(0, cy); ctx.lineTo(W, cy); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(cx, 0); ctx.lineTo(cx, H); ctx.stroke();

    // axis labels
    ctx.fillStyle = LABEL_COLOR;
    ctx.font = '11px -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif';
    ctx.textAlign = 'center';
    const labelStep = Math.round(Math.max(1, 80 / scale));
    for (let x = startX; x < W; x += step) {
      const val = Math.round((x - cx) / scale / labelStep) * labelStep;
      if (val !== 0) ctx.fillText(val, x, cy + 14);
    }
    ctx.textAlign = 'right';
    for (let y = startY; y < H; y += step) {
      const val = -Math.round((y - cy) / scale / labelStep) * labelStep;
      if (val !== 0) ctx.fillText(val, cx - 6, y + 4);
    }

    // curves
    equations.forEach(({ fn, color }) => {
      if (!fn) return;
      ctx.strokeStyle = color;
      ctx.lineWidth = 2.2;
      ctx.lineJoin = 'round';
      ctx.beginPath();
      let penDown = false;
      for (let px = 0; px < W; px++) {
        const x = (px - cx) / scale;
        let y;
        try { y = fn(x); } catch { penDown = false; continue; }
        if (!isFinite(y)) { penDown = false; continue; }
        const py = cy - y * scale;
        if (!penDown) { ctx.moveTo(px, py); penDown = true; }
        else ctx.lineTo(px, py);
      }
      ctx.stroke();
    });
  }, [equations]);

  // resize observer
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ro = new ResizeObserver(() => {
      canvas.width = canvas.offsetWidth * devicePixelRatio;
      canvas.height = canvas.offsetHeight * devicePixelRatio;
      canvas.style.width = canvas.offsetWidth + 'px';
      canvas.style.height = canvas.offsetHeight + 'px';
      const ctx = canvas.getContext('2d');
      ctx.scale(devicePixelRatio, devicePixelRatio);
      draw();
    });
    ro.observe(canvas);
    canvas.width = canvas.offsetWidth * devicePixelRatio;
    canvas.height = canvas.offsetHeight * devicePixelRatio;
    const ctx = canvas.getContext('2d');
    ctx.scale(devicePixelRatio, devicePixelRatio);
    return () => ro.disconnect();
  }, [draw]);

  useEffect(() => { draw(); }, [draw]);

  // scroll zoom
  const onWheel = useCallback((e) => {
    e.preventDefault();
    const factor = e.deltaY < 0 ? 1.1 : 0.9;
    transform.current.scale = Math.min(400, Math.max(10, transform.current.scale * factor));
    draw();
  }, [draw]);

  // pan
  const onMouseDown = useCallback((e) => {
    drag.current = { x: e.clientX, y: e.clientY, ox: transform.current.ox, oy: transform.current.oy };
  }, []);
  const onMouseMove = useCallback((e) => {
    if (!drag.current) return;
    transform.current.ox = drag.current.ox + (e.clientX - drag.current.x);
    transform.current.oy = drag.current.oy + (e.clientY - drag.current.y);
    draw();
  }, [draw]);
  const onMouseUp = useCallback(() => { drag.current = null; }, []);

  // touch pan
  const onTouchStart = useCallback((e) => {
    if (e.touches.length === 1) {
      const t = e.touches[0];
      drag.current = { x: t.clientX, y: t.clientY, ox: transform.current.ox, oy: transform.current.oy };
    }
  }, []);
  const onTouchMove = useCallback((e) => {
    if (!drag.current || e.touches.length !== 1) return;
    e.preventDefault();
    const t = e.touches[0];
    transform.current.ox = drag.current.ox + (t.clientX - drag.current.x);
    transform.current.oy = drag.current.oy + (t.clientY - drag.current.y);
    draw();
  }, [draw]);

  return (
    <canvas
      ref={canvasRef}
      style={{ width: '100%', height: '100%', display: 'block', cursor: 'crosshair' }}
      onWheel={onWheel}
      onMouseDown={onMouseDown}
      onMouseMove={onMouseMove}
      onMouseUp={onMouseUp}
      onMouseLeave={onMouseUp}
      onTouchStart={onTouchStart}
      onTouchMove={onTouchMove}
      onTouchEnd={onMouseUp}
    />
  );
}
