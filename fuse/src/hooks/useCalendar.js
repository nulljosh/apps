import { useState, useEffect, useCallback } from 'react'
import { getCustomEvents } from '../data/customSources.js'
import { parseICS } from '../lib/parseICS.js'
import { loadFeeds } from '../lib/feedStorage.js'

async function fetchFeed(feed) {
  const encoded = encodeURIComponent(feed.url)
  const r = await fetch(`/api/ical?url=${encoded}`)
  if (!r.ok) throw new Error(`${r.status}`)
  const text = await r.text()
  return parseICS(text, feed.label)
}

export function useCalendar() {
  const [events, setEvents] = useState([])
  const [now, setNow] = useState(new Date())

  const refresh = useCallback(async () => {
    const feeds = await loadFeeds()
    const cutoff = new Date()
    cutoff.setDate(cutoff.getDate() + 180)

    const custom = getCustomEvents()
    let ical = []

    if (feeds.length > 0) {
      const results = await Promise.allSettled(feeds.map(fetchFeed))
      ical = results
        .filter(r => r.status === 'fulfilled')
        .flatMap(r => r.value)
        .filter(e => e.date > new Date() && e.date < cutoff)
    }

    const all = [...ical, ...custom]
    all.sort((a, b) => a.date - b.date)
    setEvents(all)
  }, [])

  useEffect(() => {
    refresh()
  }, [refresh])

  // Re-fetch when feeds change
  useEffect(() => {
    window.addEventListener('fuse-feeds-changed', refresh)
    return () => window.removeEventListener('fuse-feeds-changed', refresh)
  }, [refresh])

  // Tick every second
  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 1000)
    return () => clearInterval(id)
  }, [])

  const upcoming = events.filter(e => e.date > now)
  const past = events.filter(e => e.date <= now)
  const next = upcoming[0] ?? null

  return { events, upcoming, past, next, now, refresh }
}
