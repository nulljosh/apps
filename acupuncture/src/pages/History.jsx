import { useSessions } from '../context/SessionContext'
import './History.css'

export default function History() {
  const { sessions, deleteSession } = useSessions()

  return (
    <div className="page">
      <h1 className="page-title fade-up">Session History</h1>
      <p className="page-subtitle fade-up">{sessions.length} session{sessions.length !== 1 ? 's' : ''} logged</p>

      {sessions.length === 0 ? (
        <div className="history-empty fade-up fade-up-1">
          <p>No sessions logged yet.</p>
          <p className="history-empty-sub">Use the foot, hand, or acupuncture pages to log your first session.</p>
        </div>
      ) : (
        <div className="history-list fade-up fade-up-1">
          {sessions.map(s => (
            <div key={s.id} className="history-item card">
              <div className="history-item-main">
                <div className="history-item-info">
                  <span className="history-item-type section-label">{s.type}</span>
                  <strong>{s.type === 'reflexology' ? s.zone : s.point}</strong>
                  {s.type === 'reflexology' && <span className="history-item-area">{s.area} reflexology</span>}
                  {s.type === 'acupuncture' && s.meridian && <span className="history-item-area">{s.meridian} meridian</span>}
                </div>
                <div className="history-item-right">
                  <span className="history-item-date">
                    {new Date(s.date).toLocaleDateString('en-CA', { month: 'short', day: 'numeric' })}
                  </span>
                  <span className="history-item-time">
                    {new Date(s.date).toLocaleTimeString('en-CA', { hour: 'numeric', minute: '2-digit' })}
                  </span>
                </div>
              </div>
              <button
                className="history-delete"
                onClick={() => deleteSession(s.id)}
                aria-label="Delete session"
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
