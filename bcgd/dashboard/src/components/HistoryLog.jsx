import { useState } from 'react';
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

export default function HistoryLog({ limit = 0 }) {
  const history = getHistory();
  const [expanded, setExpanded] = useState(false);

  if (history.length === 0) {
    return <p className="empty-hint">No stock changes yet.</p>;
  }

  const showAll = !limit || expanded;
  const visible = showAll ? history : history.slice(0, limit);
  const hasMore = limit > 0 && history.length > limit;

  return (
    <div className="history-log">
      <div className="history-list">
        {visible.map((entry, i) => (
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
      {hasMore && (
        <button
          className="btn btn-secondary btn-sm show-more-btn"
          onClick={() => setExpanded(e => !e)}
        >
          {expanded ? 'Show less' : `Show all ${history.length} entries`}
        </button>
      )}
    </div>
  );
}
