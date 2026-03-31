import { Link } from 'react-router-dom'
import { useSessions } from '../context/SessionContext'
import './Home.css'

const cards = [
  { to: '/feet', title: 'Foot Reflexology', desc: '16 pressure zones mapped to organs', icon: 'M12 21c-3 0-5-2-6-5s-1-7 1-9 5-3 5-3 3 1 5 3 2 6 1 9-3 5-6 5z' },
  { to: '/hands', title: 'Hand Reflexology', desc: '11 palm zones for quick relief', icon: 'M18 11V6a2 2 0 00-4 0v2M14 8V4a2 2 0 00-4 0v6M10 6V3a2 2 0 00-4 0v9M7 15l-2 4h14l-2-4' },
  { to: '/acupuncture', title: 'Acupuncture Points', desc: '35+ points across 11 meridians', icon: 'M12 2v6m0 4v10M9 6l3-4 3 4M9 18l3 4 3-4' },
  { to: '/symptoms', title: 'What Hurts?', desc: 'Find points for 12 common symptoms', icon: 'M9 12h6m-3-3v6m8-3a9 9 0 11-18 0 9 9 0 0118 0z' }
]

export default function Home() {
  const { sessions } = useSessions()

  return (
    <div className="page">
      <div className="home-hero fade-up">
        <div className="home-glow" />
        <h1 className="home-title">Acupuncture &<br />Reflexology</h1>
        <p className="page-subtitle">Interactive body maps and pressure point reference</p>
      </div>

      <div className="home-grid">
        {cards.map((c, i) => (
          <Link key={c.to} to={c.to} className={`home-card card fade-up fade-up-${i + 1}`}>
            <div className="home-card-icon">
              <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                <path d={c.icon} />
              </svg>
            </div>
            <h3>{c.title}</h3>
            <p>{c.desc}</p>
          </Link>
        ))}
      </div>

      {sessions.length > 0 && (
        <div className="home-recent fade-up fade-up-5">
          <div className="home-recent-header">
            <span className="section-label">Recent Sessions</span>
            <Link to="/history" className="btn btn-ghost" style={{ padding: '0.375rem 1rem', fontSize: '0.75rem' }}>View all</Link>
          </div>
          {sessions.slice(0, 3).map(s => (
            <div key={s.id} className="home-session-row">
              <span>{s.type === 'reflexology' ? s.zone : s.point}</span>
              <span className="home-session-date">{new Date(s.date).toLocaleDateString()}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
