const STATUS_COLORS = {
  Lead: '#ff9500',
  Scheduled: '#0071e3',
  'In Progress': '#ff6b00',
  Done: '#34c759',
  Cancelled: '#8e8e93',
};

function fmt(iso) {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('en-CA', { month: 'short', day: 'numeric' });
}

export default function JobList({ jobs, onEdit, onDelete, onAdvance }) {
  const active = jobs.filter(j => j.status !== 'Done' && j.status !== 'Cancelled');
  const done = jobs.filter(j => j.status === 'Done' || j.status === 'Cancelled');

  function renderJob(j) {
    const color = STATUS_COLORS[j.status] || '#8e8e93';
    const canAdvance = j.status !== 'Done' && j.status !== 'Cancelled';
    return (
      <div key={j.id} className="job-row glass-card">
        <div className="job-status-bar" style={{ background: color }}/>
        <div className="job-main">
          <div className="job-top">
            <span className="job-customer">{j.customer || 'Unknown Customer'}</span>
            <span className="job-status-pill" style={{ background: color + '22', color }}>
              {j.status}
            </span>
          </div>
          <div className="job-meta">
            {j.service && <span>{j.service}</span>}
            {j.address && <span>{j.address}</span>}
            {j.phone && <a href={`tel:${j.phone}`} className="job-phone">{j.phone}</a>}
            {j.scheduledAt && <span>{fmt(j.scheduledAt)}</span>}
          </div>
          {j.notes && <div className="job-notes">{j.notes}</div>}
        </div>
        <div className="job-actions">
          {canAdvance && (
            <button className="btn btn-primary btn-sm" onClick={() => onAdvance(j.id)}>Advance</button>
          )}
          <button className="btn-icon" onClick={() => onEdit(j)} title="Edit">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
            </svg>
          </button>
          <button className="btn-icon btn-danger" onClick={() => onDelete(j.id)} title="Delete">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/>
            </svg>
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="job-list">
      {active.map(renderJob)}
      {done.length > 0 && (
        <details className="done-jobs">
          <summary className="done-jobs-toggle">{done.length} completed / cancelled</summary>
          {done.map(renderJob)}
        </details>
      )}
    </div>
  );
}
