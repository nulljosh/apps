export default async function handler(req, res) {
  const { url } = req.query
  if (!url) return res.status(400).json({ error: 'url required' })

  let target
  try {
    target = new URL(decodeURIComponent(url))
  } catch {
    return res.status(400).json({ error: 'invalid url' })
  }

  // Only allow https ICS sources
  if (target.protocol !== 'https:') {
    return res.status(400).json({ error: 'https only' })
  }

  try {
    const r = await fetch(target.toString(), {
      headers: { 'User-Agent': 'fuse/1.1.0 ical-proxy' },
      signal: AbortSignal.timeout(8000),
    })
    if (!r.ok) return res.status(502).json({ error: `upstream ${r.status}` })
    const text = await r.text()
    res.setHeader('Content-Type', 'text/calendar; charset=utf-8')
    res.setHeader('Cache-Control', 'no-store')
    res.setHeader('Access-Control-Allow-Origin', '*')
    res.status(200).send(text)
  } catch (e) {
    res.status(502).json({ error: e.message })
  }
}
