import { useState, useEffect, useCallback } from 'react'
import { getCustomEvents, getMockCalendarEvents } from '../data/customSources.js'

export function useCalendar() {
  const [events, setEvents] = useState([])
  const [now, setNow] = useState(new Date())

  const refresh = useCallback(() => {
    const all = [
      ...getMockCalendarEvents(),
      ...getCustomEvents(),
    ]
    all.sort((a, b) => a.date - b.date)
    setEvents(all)
  }, [])

  useEffect(() => {
    refresh()
  }, [refresh])

  // Tick every second for countdown updates
  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 1000)
    return () => clearInterval(id)
  }, [])

  const upcoming = events.filter(e => e.date > now)
  const past = events.filter(e => e.date <= now)
  const next = upcoming[0] ?? null

  return { events, upcoming, past, next, now, refresh }
}
