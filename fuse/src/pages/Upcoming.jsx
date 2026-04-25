import { useCalendar } from '../hooks/useCalendar.js'

function formatCountdown(ms) {
  const total = Math.max(0, Math.floor(ms / 1000))
  const m = Math.floor(total / 60) % 60
  const h = Math.floor(total / 3600) % 24
  const d = Math.floor(total / 86400)
  if (d > 0) return `${d}d ${h}h`
  if (h > 0) return `${h}h ${String(m).padStart(2,'0')}m`
  return `${String(m).padStart(2,'0')}m`
}

function urgencyColor(ms) {
  const h = ms / 3600000
  if (h <= 24) return 'var(--danger)'
  if (h <= 72) return 'var(--warn)'
  return 'var(--accent)'
}

export default function Upcoming() {
  const { upcoming, now } = useCalendar()

  return (
    <div className="page">
      <div className="page-header fade-up">
        <div className="section-label">fuse</div>
        <div className="page-title">upcoming</div>
      </div>

      <div className="section-label" style={{ marginBottom: 12 }}>{upcoming.length} events</div>

      {upcoming.map((event, i) => {
        const ms = event.date - now
        return (
          <div key={event.id} className={`glass upcoming-item fade-up fade-up-delay-${Math.min(i + 1, 4)}`}>
            <div className="upcoming-rank">{i + 1}</div>
            <div className="upcoming-info">
              <div className="upcoming-name">{event.title}</div>
              <div className="upcoming-time">
                {event.date.toLocaleDateString([], { weekday: 'short', month: 'short', day: 'numeric' })}
                {!event.allDay && ` · ${event.date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`}
              </div>
            </div>
            <div className="upcoming-countdown" style={{ color: urgencyColor(ms) }}>
              {formatCountdown(ms)}
            </div>
          </div>
        )
      })}
    </div>
  )
}
