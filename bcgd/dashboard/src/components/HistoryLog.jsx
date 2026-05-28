import { getHistory } from '../lib/storage';

const ACTION_COLORS = {
  added: '#34c759',
  updated: '#0071e3',
  removed: '#ff3b30',
  restocked: '#34c759',
  used: '#ff9500',
};

function relTime(iso) {
  const diff = Date.now() - new Date(iso).getTime();
  const s = Math.floor(diff / 1000);
  if (s < 60) return `${s}s ago`;
  const m = Math.floor(s / 60);
  if (m < 60) return `${m}m ago`;
  const h = Math.floor(m / 60);
  if (h < 24) return `${h}h ago`;
  const d = Math.floor(h / 24);
  return `${d}d ago`;
}

export default function HistoryLog({ limit = 20 }) {
  const history = getHistory().slice(0, limit);

  if (!history.length) return (
    <div className="history-log glass-card">
      <p className="empty-hint" style={{ padding: '16px' }}>No activity yet.</p>
    </div>
  );

  return (
    <div className="history-log glass-card">
      {history.map(h => (
        <div key={h.id} className="history-row">
          <span
            className="history-action"
            style={{ color: ACTION_COLORS[h.action] || '#8e8e93' }}
          >
            {h.action}
          </span>
          <span className="history-name">{h.partName}</span>
          {h.sku && <span className="history-sku">{h.sku}</span>}
          {h.details && <span className="history-details">{h.details}</span>}
          <span className="history-time">{relTime(h.timestamp)}</span>
        </div>
      ))}
    </div>
  );
}
