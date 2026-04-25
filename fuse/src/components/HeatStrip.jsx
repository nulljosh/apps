// Heat strip: shows event density over the next 30 days

export default function HeatStrip({ events, now }) {
  const days = 30
  const cells = Array.from({ length: days }, (_, i) => {
    const start = new Date(now)
    start.setDate(start.getDate() + i)
    start.setHours(0, 0, 0, 0)
    const end = new Date(start)
    end.setDate(end.getDate() + 1)
    const count = events.filter(e => e.date >= start && e.date < end).length
    return count
  })

  const max = Math.max(1, ...cells)

  function cellColor(count) {
    if (count === 0) return 'rgba(255,255,255,0.04)'
    const intensity = count / max
    if (intensity > 0.7) return 'rgba(255,59,48,0.6)'
    if (intensity > 0.4) return 'rgba(255,159,10,0.5)'
    return 'rgba(0,113,227,0.4)'
  }

  return (
    <div>
      <div className="section-label">next 30 days</div>
      <div className="heat-strip">
        {cells.map((count, i) => (
          <div
            key={i}
            className="heat-cell"
            style={{ background: cellColor(count) }}
            title={`Day +${i}: ${count} event${count !== 1 ? 's' : ''}`}
          />
        ))}
      </div>
    </div>
  )
}
