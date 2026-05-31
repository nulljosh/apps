function relTime(iso) {
  if (!iso) return '';
  const diff = Date.now() - new Date(iso).getTime();
  const s = Math.floor(diff / 1000);
  if (s < 60) return `${s}s ago`;
  const m = Math.floor(s / 60);
  if (m < 60) return `${m}m ago`;
  const h = Math.floor(m / 60);
  if (h < 24) return `${h}h ago`;
  return `${Math.floor(h / 24)}d ago`;
}

// Read-only inbox of website booking submissions. Each lead can be converted
// into a job (prefills the job form) or dismissed.
export default function LeadList({ leads, onConvert, onDismiss }) {
  if (!leads.length) {
    return <p className="empty-hint">No booking requests yet. Submissions from the website land here.</p>;
  }

  return (
    <div className="lead-list glass-card">
      {leads.map(l => (
        <div key={l.id} className="lead-row">
          <div className="lead-info">
            <div className="lead-top">
              <span className="lead-name">{l.name || 'Unknown'}</span>
              {l.service && <span className="lead-service">{l.service}</span>}
              <span className="lead-time">{relTime(l.created_at)}</span>
            </div>
            <div className="lead-contact">
              {l.phone && <a href={`tel:${l.phone}`}>{l.phone}</a>}
              {l.email && <a href={`mailto:${l.email}`}>{l.email}</a>}
            </div>
            {l.message && <div className="lead-message">{l.message}</div>}
          </div>
          <div className="lead-actions">
            <button className="btn btn-primary btn-sm" onClick={() => onConvert(l)}>Convert to job</button>
            <button className="btn btn-secondary btn-sm" onClick={() => onDismiss(l.id)}>Dismiss</button>
          </div>
        </div>
      ))}
    </div>
  );
}
