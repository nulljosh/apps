import { useMemo } from 'react'
import { useCalendar } from '../hooks/useCalendar.js'
import CountdownTile from '../components/CountdownTile.jsx'
import HeatStrip from '../components/HeatStrip.jsx'

function groupByDay(events) {
  const groups = new Map()
  for (const e of events) {
    const key = e.date.toDateString()
    if (!groups.has(key)) groups.set(key, { date: e.date, events: [] })
    groups.get(key).events.push(e)
  }
  return [...groups.values()]
}

function dayLabel(date, now) {
  const diff = Math.floor((date.setHours(0,0,0,0) - new Date(now).setHours(0,0,0,0)) / 86400000)
  if (diff === 0) return 'today'
  if (diff === 1) return 'tomorrow'
  if (diff <= 6) return date.toLocaleDateString([], { weekday: 'long' }).toLowerCase()
  return date.toLocaleDateString([], { weekday: 'short', month: 'short', day: 'numeric' }).toLowerCase()
}

export default function Timeline() {
  const { upcoming, next, now, events } = useCalendar()
  const groups = useMemo(() => groupByDay(upcoming), [upcoming])
  // Span from now to last event for fuse bar
  const lastMs = upcoming.at(-1)?.date - now || 1
  const nextMs = next ? next.date - now : null

  return (
    <div className="page">
      <div className="page-header fade-up">
        <div className="section-label">fuse</div>
        <div className="page-title">timeline</div>
      </div>

      <HeatStrip events={upcoming} now={now} />

      {next && (
        <CountdownTile
          event={next}
          now={now}
          large
          totalMs={nextMs + 86400000}
        />
      )}

      {groups.map((group, gi) => (
        <div key={group.date.toDateString()}>
          <div className="day-header">
            <span className="day-header-date">
              {group.date.toLocaleDateString([], { month: 'short', day: 'numeric' })}
            </span>
            <span className="day-header-label">{dayLabel(new Date(group.date), now)}</span>
          </div>

          {group.events.map((event, i) => (
            <CountdownTile
              key={event.id}
              event={event}
              now={now}
              totalMs={lastMs}
              style={{ animationDelay: `${(gi + i) * 0.04}s` }}
            />
          ))}
        </div>
      ))}

      {upcoming.length === 0 && (
        <div className="glass" style={{ padding: 32, textAlign: 'center', color: 'var(--text-tertiary)' }}>
          no upcoming events
        </div>
      )}
    </div>
  )
}
