/**
 * Charts -- canvas-based chart rendering.
 * Renders bar charts and line charts with Dark Editorial palette.
 */
const Charts = (() => {

  const COLORS = {
    green: '#3d9e6a',
    amber: '#d4a843',
    muted: '#8a9e90',
    bg: '#0c1a12',
    cardBg: '#0f2318',
    gridLine: 'rgba(138, 158, 144, 0.15)',
    text: '#e8e4da',
    textMuted: '#8a9e90'
  };

  const PROVIDER_COLORS = {
    claude: '#3d9e6a',
    chatgpt: '#d4a843',
    custom: '#4e9cd7'
  };

  function getCtx(canvasId) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return null;
    const dpr = window.devicePixelRatio || 1;
    const rect = canvas.getBoundingClientRect();
    canvas.width = rect.width * dpr;
    canvas.height = rect.height * dpr;
    const ctx = canvas.getContext('2d');
    ctx.scale(dpr, dpr);
    return { ctx, w: rect.width, h: rect.height };
  }

  function setupChart(canvasId, data, options = {}) {
    const result = getCtx(canvasId);
    if (!result) return null;
    const { ctx, w, h } = result;
    const { valueKey = 'conversations', label = '' } = options;

    ctx.clearRect(0, 0, w, h);

    if (!data || data.length === 0) {
      ctx.fillStyle = COLORS.textMuted;
      ctx.font = '13px "DM Sans", sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('No data yet', w / 2, h / 2);
      return null;
    }

    const padding = { top: 30, right: 20, bottom: 50, left: 55 };
    const chartW = w - padding.left - padding.right;
    const chartH = h - padding.top - padding.bottom;

    const values = data.map((d) => d[valueKey] || 0);
    const maxVal = Math.max(...values, 1);

    if (label) {
      ctx.fillStyle = COLORS.textMuted;
      ctx.font = '11px "DM Sans", sans-serif';
      ctx.textAlign = 'left';
      ctx.fillText(label.toUpperCase(), padding.left, 18);
    }

    const gridSteps = 4;
    for (let i = 0; i <= gridSteps; i++) {
      const y = padding.top + (chartH * i / gridSteps);
      ctx.strokeStyle = COLORS.gridLine;
      ctx.lineWidth = 0.5;
      ctx.beginPath();
      ctx.moveTo(padding.left, y);
      ctx.lineTo(w - padding.right, y);
      ctx.stroke();

      const val = Math.round(maxVal * (1 - i / gridSteps));
      ctx.fillStyle = COLORS.textMuted;
      ctx.font = '10px "DM Sans", sans-serif';
      ctx.textAlign = 'right';
      ctx.fillText(formatNumber(val), padding.left - 8, y + 4);
    }

    return { ctx, w, h, padding, chartW, chartH, maxVal };
  }

  function drawBarChart(canvasId, data, options = {}) {
    const { labelKey = 'date', valueKey = 'conversations', color = COLORS.green } = options;
    const setup = setupChart(canvasId, data, options);
    if (!setup) return;
    const { ctx, w, padding, chartW, chartH, maxVal } = setup;

    // Bars
    const barGap = Math.max(2, chartW * 0.02);
    const barWidth = Math.max(4, (chartW - barGap * (data.length + 1)) / data.length);

    data.forEach((d, i) => {
      const val = d[valueKey] || 0;
      const barH = (val / maxVal) * chartH;
      const x = padding.left + barGap + i * (barWidth + barGap);
      const y = padding.top + chartH - barH;

      const barColor = d.provider ? (PROVIDER_COLORS[d.provider] || color) : color;
      ctx.fillStyle = barColor;
      ctx.globalAlpha = 0.85;
      roundRect(ctx, x, y, barWidth, barH, 3);
      ctx.fill();
      ctx.globalAlpha = 1;

      // X labels (skip some if too many)
      const labelStr = d[labelKey] || '';
      const showLabel = data.length <= 14 || i % Math.ceil(data.length / 10) === 0;
      if (showLabel && labelStr) {
        ctx.save();
        ctx.translate(x + barWidth / 2, padding.top + chartH + 12);
        ctx.rotate(-0.5);
        ctx.fillStyle = COLORS.textMuted;
        ctx.font = '9px "DM Sans", sans-serif';
        ctx.textAlign = 'right';
        const display = labelStr.length > 5 ? labelStr.slice(5) : labelStr;
        ctx.fillText(display, 0, 0);
        ctx.restore();
      }
    });
  }

  function drawLineChart(canvasId, data, options = {}) {
    const { valueKey = 'tokens', color = COLORS.amber } = options;
    const setup = setupChart(canvasId, data, { ...options, valueKey });
    if (!setup) return;
    const { ctx, padding, chartW, chartH, maxVal } = setup;

    // Line path
    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.lineJoin = 'round';
    ctx.lineCap = 'round';
    ctx.beginPath();

    const points = data.map((d, i) => {
      const val = d[valueKey] || 0;
      const x = padding.left + (i / Math.max(data.length - 1, 1)) * chartW;
      const y = padding.top + chartH - (val / maxVal) * chartH;
      return { x, y };
    });

    points.forEach((p, i) => {
      if (i === 0) ctx.moveTo(p.x, p.y);
      else ctx.lineTo(p.x, p.y);
    });
    ctx.stroke();

    // Fill area
    ctx.lineTo(points[points.length - 1].x, padding.top + chartH);
    ctx.lineTo(points[0].x, padding.top + chartH);
    ctx.closePath();
    ctx.fillStyle = color.replace(')', ', 0.1)').replace('rgb', 'rgba');
    if (color.startsWith('#')) {
      ctx.fillStyle = hexToRgba(color, 0.1);
    }
    ctx.fill();

    // Dots
    points.forEach((p) => {
      ctx.beginPath();
      ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
      ctx.fillStyle = color;
      ctx.fill();
    });
  }

  function drawProviderPie(canvasId, providerData) {
    const result = getCtx(canvasId);
    if (!result) return;
    const { ctx, w, h } = result;

    ctx.clearRect(0, 0, w, h);

    if (!providerData || providerData.length === 0) {
      ctx.fillStyle = COLORS.textMuted;
      ctx.font = '13px "DM Sans", sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('No data yet', w / 2, h / 2);
      return;
    }

    const total = providerData.reduce((s, p) => s + p.conversations, 0);
    if (total === 0) {
      ctx.fillStyle = COLORS.textMuted;
      ctx.font = '13px "DM Sans", sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText('No conversations logged', w / 2, h / 2);
      return;
    }

    const cx = w * 0.35;
    const cy = h / 2;
    const radius = Math.min(cx - 20, cy - 20, 80);
    let startAngle = -Math.PI / 2;

    providerData.forEach((p) => {
      const slice = (p.conversations / total) * Math.PI * 2;
      const color = PROVIDER_COLORS[p.provider] || COLORS.muted;

      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.arc(cx, cy, radius, startAngle, startAngle + slice);
      ctx.closePath();
      ctx.fillStyle = color;
      ctx.globalAlpha = 0.85;
      ctx.fill();
      ctx.globalAlpha = 1;

      startAngle += slice;
    });

    // Legend
    const legendX = w * 0.65;
    let legendY = cy - (providerData.length * 24) / 2;

    providerData.forEach((p) => {
      const color = PROVIDER_COLORS[p.provider] || COLORS.muted;
      ctx.fillStyle = color;
      roundRect(ctx, legendX, legendY, 12, 12, 2);
      ctx.fill();

      ctx.fillStyle = COLORS.text;
      ctx.font = '12px "DM Sans", sans-serif';
      ctx.textAlign = 'left';
      const pct = Math.round((p.conversations / total) * 100);
      ctx.fillText(`${capitalize(p.provider)} (${pct}%)`, legendX + 20, legendY + 10);
      legendY += 24;
    });
  }

  // Helpers
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

  function hexToRgba(hex, alpha) {
    const r = parseInt(hex.slice(1, 3), 16);
    const g = parseInt(hex.slice(3, 5), 16);
    const b = parseInt(hex.slice(5, 7), 16);
    return `rgba(${r}, ${g}, ${b}, ${alpha})`;
  }

  function formatNumber(n) {
    if (n >= 1000000) return (n / 1000000).toFixed(1) + 'M';
    if (n >= 1000) return (n / 1000).toFixed(1) + 'K';
    return String(n);
  }

  function capitalize(s) {
    return s.charAt(0).toUpperCase() + s.slice(1);
  }

  return {
    drawBarChart,
    drawLineChart,
    drawProviderPie,
    PROVIDER_COLORS
  };
})();
