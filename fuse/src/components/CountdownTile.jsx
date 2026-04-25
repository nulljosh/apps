import { useMemo } from 'react'

function pad(n) { return String(Math.max(0, n)).padStart(2, '0') }

function breakdown(ms) {
  const total = Math.max(0, Math.floor(ms / 1000))
  const s = total % 60
  const m = Math.floor(total / 60) % 60
  const h = Math.floor(total / 3600) % 24
  const d = Math.floor(total / 86400)
  return { d, h, m, s, total }
}

function urgency(ms) {
  const h = ms / 3600000
  if (h <= 24) return 'high'
  if (h <= 72) return 'medium'
  return 'low'
}

export default function CountdownTile({ event, now, large = false, totalMs }) {
  const ms = event.date - now
  const { d, h, m, s } = useMemo(() => breakdown(ms), [ms])
  const level = urgency(ms)
  const pct = totalMs ? Math.max(0, Math.min(100, (ms / totalMs) * 100)) : null

  return (
    <div className={`glass event-card fade-up ${large ? 'now-hero' : ''}`}>
      {large && <div className="now-label">next up</div>}
      {large && <div className="now-event-name">{event.title}</div>}

      <div style={{ display: 'flex', gap: 4, alignItems: 'flex-end', justifyContent: large ? 'center' : 'flex-start' }}>
        {d > 0 && (
          <div style={{ textAlign: 'center' }}>
            <div className={`countdown-digits${large ? ' large' : ''} urgency-${level}`}>{pad(d)}</div>
            <div className="countdown-unit">day{d !== 1 ? 's' : ''}</div>
          </div>
        )}
        {d > 0 && <div className={`countdown-digits${large ? ' large' : ''} urgency-${level} ticking-colon`} style={{ paddingBottom: large ? 14 : 10 }}>:</div>}
        <div style={{ textAlign: 'center' }}>
          <div className={`countdown-digits${large ? ' large' : ''} urgency-${level}`}>{pad(h)}</div>
          <div className="countdown-unit">hr</div>
        </div>
        <div className={`countdown-digits${large ? ' large' : ''} urgency-${level} ticking-colon`} style={{ paddingBottom: large ? 14 : 10 }}>:</div>
        <div style={{ textAlign: 'center' }}>
          <div className={`countdown-digits${large ? ' large' : ''} urgency-${level}`}>{pad(m)}</div>
          <div className="countdown-unit">min</div>
        </div>
        <div className={`countdown-digits${large ? ' large' : ''} urgency-${level} ticking-colon`} style={{ paddingBottom: large ? 14 : 10 }}>:</div>
        <div style={{ textAlign: 'center' }}>
          <div className={`countdown-digits${large ? ' large' : ''} urgency-${level}`}>{pad(s)}</div>
          <div className="countdown-unit">sec</div>
        </div>
      </div>

      {pct !== null && (
        <div className="fuse-bar" style={{ marginTop: large ? 20 : 12 }}>
          <div className={`fuse-bar-fill fuse-${level}`} style={{ width: `${pct}%` }} />
        </div>
      )}

      {!large && (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
          <div className="event-card-meta">
            {event.allDay ? 'all day' : event.date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
            {' · '}{event.source}
          </div>
          <span className={`event-badge badge-${event.category}`}>{event.category === 'payday' ? 'payday' : event.source}</span>
        </div>
      )}
    </div>
  )
}
