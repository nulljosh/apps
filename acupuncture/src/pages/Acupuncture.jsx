import { useState } from 'react'
import { meridians } from '../data/acupuncture'
import { useSessions } from '../context/SessionContext'
import './Acupuncture.css'

export default function Acupuncture() {
  const [activeMeridian, setActiveMeridian] = useState(null)
  const [activePoint, setActivePoint] = useState(null)
  const { addSession } = useSessions()

  const meridian = meridians.find(m => m.id === activeMeridian)

  return (
    <div className="page">
      <h1 className="page-title fade-up">Acupuncture Points</h1>
      <p className="page-subtitle fade-up">35+ points organized by meridian</p>

      <div className="meridian-chips fade-up fade-up-1">
        {meridians.map(m => (
          <button
            key={m.id}
            className={`chip ${activeMeridian === m.id ? 'active' : ''}`}
            style={activeMeridian === m.id ? { background: m.color, borderColor: m.color } : {}}
            onClick={() => { setActiveMeridian(activeMeridian === m.id ? null : m.id); setActivePoint(null) }}
          >
            <span className="meridian-abbr">{m.abbr}</span>
            {m.name}
          </button>
        ))}
      </div>

      {meridian && (
        <div className="meridian-points fade-up">
          {meridian.points.map(p => (
            <div
              key={p.id}
              className={`point-card card ${activePoint === p.id ? 'point-card-active' : ''}`}
              onClick={() => setActivePoint(activePoint === p.id ? null : p.id)}
            >
              <div className="point-card-header">
                <span className="point-id" style={{ color: meridian.color }}>{p.id}</span>
                <div>
                  <h3 className="point-name">{p.name}</h3>
                  <span className="point-english">{p.english}</span>
                </div>
              </div>

              {activePoint === p.id && (
                <div className="point-expanded fade-up">
                  <div className="point-field">
                    <span className="section-label">Location</span>
                    <p>{p.location}</p>
                  </div>
                  <div className="point-field">
                    <span className="section-label">Technique</span>
                    <p>{p.technique}</p>
                  </div>
                  <div className="point-field">
                    <span className="section-label">Indications</span>
                    <div className="point-indications">
                      {p.indications.map(ind => (
                        <span key={ind} className="chip" style={{ cursor: 'default', borderColor: meridian.color + '44' }}>{ind}</span>
                      ))}
                    </div>
                  </div>
                  <button
                    className="btn btn-primary"
                    style={{ width: '100%', marginTop: '0.75rem' }}
                    onClick={e => {
                      e.stopPropagation()
                      addSession({ type: 'acupuncture', point: `${p.id} ${p.name}`, meridian: meridian.name, notes: '' })
                    }}
                  >
                    Log session
                  </button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {!meridian && (
        <div className="meridian-overview fade-up fade-up-2">
          {meridians.map(m => (
            <button
              key={m.id}
              className="meridian-row card"
              onClick={() => { setActiveMeridian(m.id); setActivePoint(null) }}
            >
              <div className="meridian-row-dot" style={{ background: m.color }} />
              <div className="meridian-row-info">
                <strong>{m.name}</strong>
                <span>{m.points.length} points</span>
              </div>
              <span className="meridian-row-abbr" style={{ color: m.color }}>{m.abbr}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}
