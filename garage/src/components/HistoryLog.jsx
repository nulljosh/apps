import { getHistory } from '../lib/storage';

function formatTime(ts) {
  const d = new Date(ts);
  const now = new Date();
  const diff = now - d;

  if (diff < 60000) return 'Just now';
  if (diff < 3600000) return `${Math.floor(diff / 60000)}m ago`;
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}h ago`;

  return d.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  });
}

const ACTION_COLORS = {
  added: '#34c759',
  updated: '#0071e3',
  removed: '#ff3b30',
  restocked: '#34c759',
  used: '#ff9500',
};

export default function HistoryLog() {
  const history = getHistory();

  if (history.length === 0) {
    return (
      <div className="empty-state animate__animated animate__fadeIn">
        <h2>No history yet</h2>
        <p>Stock changes will appear here as you manage inventory.</p>
      </div>
    );
  }

  return (
    <div className="history-log">
      <h2 className="section-title animate__animated animate__fadeIn">Stock History</h2>
      <div className="history-list">
        {history.map((entry, i) => (
          <div
            key={entry.timestamp + i}
            className="history-row glass-card animate__animated animate__fadeInUp"
            style={{ animationDelay: `${Math.min(i * 0.03, 0.3)}s` }}
          >
            <span
              className="history-action"
              style={{ color: ACTION_COLORS[entry.action] || '#86868b' }}
            >
              {entry.action}
            </span>
            <span className="history-name">{entry.partName}</span>
            <span className="history-sku mono">{entry.sku}</span>
            <span className="history-details">{entry.details}</span>
            <span className="history-time">{formatTime(entry.timestamp)}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
