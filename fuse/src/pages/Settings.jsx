import { useState, useEffect } from 'react'
import { loadFeeds, saveFeeds } from '../lib/feedStorage.js'

export default function Settings() {
  const [feeds, setFeeds] = useState([])
  const [input, setInput] = useState('')
  const [label, setLabel] = useState('')
  const [error, setError] = useState('')

  useEffect(() => { loadFeeds().then(setFeeds) }, [])

  async function add() {
    const url = input.trim()
    if (!url) return
    if (!url.startsWith('https://')) { setError('URL must start with https://'); return }
    if (feeds.some(f => f.url === url)) { setError('Already added'); return }
    const next = [...feeds, { url, label: label.trim() || 'Calendar' }]
    setFeeds(next)
    await saveFeeds(next)
    setInput('')
    setLabel('')
    setError('')
    window.dispatchEvent(new Event('fuse-feeds-changed'))
  }

  async function remove(url) {
    const next = feeds.filter(f => f.url !== url)
    setFeeds(next)
    await saveFeeds(next)
    window.dispatchEvent(new Event('fuse-feeds-changed'))
  }

  return (
    <div className="page">
      <div className="page-header fade-up">
        <div className="section-label">fuse</div>
        <div className="page-title">calendars</div>
      </div>

      <div className="glass" style={{ padding: '16px 16px 20px', marginBottom: 16 }}>
        <div className="section-label" style={{ marginBottom: 12 }}>add calendar</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <input
            className="cal-input"
            placeholder="Name (optional)"
            value={label}
            onChange={e => setLabel(e.target.value)}
          />
          <input
            className="cal-input"
            placeholder="ICS URL (https://...)"
            value={input}
            onChange={e => { setInput(e.target.value); setError('') }}
            onKeyDown={e => e.key === 'Enter' && add()}
          />
          {error && <div style={{ fontSize: '0.75rem', color: 'var(--danger)' }}>{error}</div>}
          <button className="cal-btn" onClick={add}>Add Calendar</button>
        </div>
        <div style={{ marginTop: 14, fontSize: '0.72rem', color: 'var(--text-tertiary)', lineHeight: 1.5 }}>
          In Google Calendar: Settings &gt; [Calendar] &gt; "Secret address in iCal format"
        </div>
      </div>

      {feeds.length > 0 && (
        <div>
          <div className="section-label" style={{ marginBottom: 10 }}>{feeds.length} connected</div>
          {feeds.map(f => (
            <div key={f.url} className="glass upcoming-item" style={{ marginBottom: 8 }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="upcoming-name">{f.label}</div>
                <div className="upcoming-time" style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{f.url}</div>
              </div>
              <button
                onClick={() => remove(f.url)}
                style={{ background: 'none', border: 'none', color: 'var(--danger)', cursor: 'pointer', fontSize: '0.8rem', letterSpacing: '0.04em', textTransform: 'uppercase', flexShrink: 0, padding: '4px 8px' }}
              >
                remove
              </button>
            </div>
          ))}
        </div>
      )}

      {feeds.length === 0 && (
        <div className="glass" style={{ padding: 32, textAlign: 'center', color: 'var(--text-tertiary)', fontSize: '0.85rem' }}>
          no calendars connected
        </div>
      )}
    </div>
  )
}
