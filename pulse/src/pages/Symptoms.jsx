import { useState } from 'react'
import { symptoms } from '../data/symptoms'
import { footZones, handZones } from '../data/reflexology'
import { getAllPoints } from '../data/acupuncture'
import './Symptoms.css'

const allPoints = getAllPoints()
const allZones = [...footZones, ...handZones]

export default function Symptoms() {
  const [query, setQuery] = useState('')
  const [active, setActive] = useState(null)

  const filtered = query.trim()
    ? symptoms.filter(s =>
        s.name.toLowerCase().includes(query.toLowerCase()) ||
        s.selfCare.toLowerCase().includes(query.toLowerCase())
      )
    : symptoms

  const symptom = symptoms.find(s => s.id === active)

  return (
    <div className="page">
      <h1 className="page-title fade-up">What Hurts?</h1>
      <div className="symptom-search fade-up">
        <input
          type="text"
          className="symptom-search-input"
          placeholder="Type a symptom... headache, back pain, stress..."
          value={query}
          onChange={e => { setQuery(e.target.value); setActive(null) }}
          autoFocus
        />
      </div>

      <div className="symptom-grid fade-up fade-up-1">
        {filtered.map(s => (
          <button
            key={s.id}
            className={`symptom-btn card ${active === s.id ? 'symptom-btn-active' : ''}`}
            onClick={() => setActive(active === s.id ? null : s.id)}
          >
            {s.name}
          </button>
        ))}
        {filtered.length === 0 && (
          <p style={{ gridColumn: '1/-1', textAlign: 'center', color: 'var(--muted)', padding: '2rem' }}>
            No matching symptoms. Try a different term.
          </p>
        )}
      </div>

      {symptom && (
        <div className="symptom-detail fade-up">
          <h2>{symptom.name}</h2>

          <div className="symptom-section">
            <span className="section-label">Self-Care Protocol</span>
            <p className="symptom-selfcare">{symptom.selfCare}</p>
          </div>

          <div className="symptom-section">
            <span className="section-label">Reflexology Zones</span>
            <div className="symptom-items">
              {symptom.reflexZones.map(zId => {
                const zone = allZones.find(z => z.id === zId)
                if (!zone) return null
                return (
                  <div key={zId} className="symptom-item card">
                    <strong>{zone.name}</strong>
                    <span className="symptom-item-sub">{zone.location}</span>
                    <span className="symptom-item-tech">{zone.technique}</span>
                  </div>
                )
              })}
            </div>
          </div>

          <div className="symptom-section">
            <span className="section-label">Acupuncture Points</span>
            <div className="symptom-items">
              {symptom.acuPoints.map(pId => {
                const point = allPoints.find(p => p.id === pId)
                if (!point) return null
                return (
                  <div key={pId} className="symptom-item card">
                    <div className="symptom-point-header">
                      <span className="symptom-point-id" style={{ color: point.meridianColor }}>{point.id}</span>
                      <strong>{point.name}</strong>
                    </div>
                    <span className="symptom-item-sub">{point.location}</span>
                    <span className="symptom-item-tech">{point.technique}</span>
                  </div>
                )
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
