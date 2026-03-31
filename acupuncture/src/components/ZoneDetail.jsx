import { bodySystemColors } from '../data/reflexology'
import './ZoneDetail.css'

export default function ZoneDetail({ zone, onLogSession }) {
  if (!zone) return null

  const color = bodySystemColors[zone.system]

  return (
    <div className="zone-detail card fade-up">
      <div className="zone-detail-header">
        <div className="zone-dot" style={{ background: color }} />
        <div>
          <h3>{zone.name}</h3>
          <span className="section-label">{zone.organ} -- {zone.system}</span>
        </div>
      </div>
      <div className="zone-detail-body">
        <div className="zone-field">
          <span className="section-label">Location</span>
          <p>{zone.location}</p>
        </div>
        <div className="zone-field">
          <span className="section-label">Technique</span>
          <p>{zone.technique}</p>
        </div>
        <div className="zone-field">
          <span className="section-label">Duration</span>
          <p>{zone.duration}</p>
        </div>
        <div className="zone-field">
          <span className="section-label">Benefits</span>
          <div className="zone-benefits">
            {zone.benefits.map(b => (
              <span key={b} className="chip" style={{ borderColor: color + '44', cursor: 'default' }}>{b}</span>
            ))}
          </div>
        </div>
      </div>
      <button className="btn btn-primary zone-log-btn" onClick={() => onLogSession(zone)}>
        Log session
      </button>
    </div>
  )
}
