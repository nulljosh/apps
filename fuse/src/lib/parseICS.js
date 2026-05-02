function unfold(text) {
  return text.replace(/\r?\n[ \t]/g, '')
}

function parseDate(raw, allDay) {
  // DTSTART;TZID=America/Vancouver:20261225T100000
  // DTSTART:20261225T100000Z
  // DTSTART;VALUE=DATE:20261225
  const val = raw.includes(':') ? raw.split(':').slice(1).join(':') : raw
  const hasTime = val.includes('T')
  const isUTC = val.endsWith('Z')

  if (!hasTime) {
    // All-day: YYYYMMDD
    const m = val.match(/(\d{4})(\d{2})(\d{2})/)
    if (!m) return null
    return new Date(`${m[1]}-${m[2]}-${m[3]}T00:00:00`)
  }

  const m = val.replace('Z', '').match(/(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})/)
  if (!m) return null
  const iso = `${m[1]}-${m[2]}-${m[3]}T${m[4]}:${m[5]}:${m[6]}${isUTC ? 'Z' : ''}`
  return new Date(iso)
}

export function parseICS(text, source = 'Calendar') {
  const unfolded = unfold(text)
  const events = []
  const blocks = unfolded.split(/BEGIN:VEVENT/i)

  for (let i = 1; i < blocks.length; i++) {
    const block = blocks[i]
    const get = (key) => {
      const m = block.match(new RegExp(`${key}[^:\r\n]*:([^\r\n]+)`, 'i'))
      return m ? m[1].trim() : null
    }

    const title = get('SUMMARY')
    const dtstart = get('DTSTART')
    const uid = get('UID')
    const status = get('STATUS')

    if (!title || !dtstart) continue
    if (status === 'CANCELLED') continue

    const allDay = !dtstart.includes('T') || dtstart.toUpperCase().includes('VALUE=DATE')
    const date = parseDate(dtstart, allDay)
    if (!date || isNaN(date)) continue

    events.push({
      id: uid || `ics-${i}-${Date.now()}`,
      title,
      date,
      allDay,
      category: 'ical',
      source,
    })
  }

  return events
}
