// Flights proxy — OpenSky Network (free, no auth)
// Returns live flight states within a bounding box
// Cache: 60s in-memory keyed by bbox (matches OpenSky rate limits)

const OPENSKY_BASE = 'https://opensky-network.org/api';
const OPENSKY_TOKEN_URL = 'https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token';
const MAX_LAT_SPAN = 2.0;
const MAX_LON_SPAN = 2.0;
const MIN_ALTITUDE_FT = 500;

const cache = new Map(); // key: bbox string → { data, ts }
const CACHE_TTL = 60_000; // 60 seconds

let token = null; // { access, exp } — OAuth2 client-credentials, cached in-process

// OpenSky retired Basic auth in 2025; authenticate via OAuth2 client credentials.
async function getOpenSkyToken() {
  const id = process.env.OPENSKY_CLIENT_ID;
  const secret = process.env.OPENSKY_CLIENT_SECRET;
  if (!id || !secret) return null;
  if (token && Date.now() < token.exp) return token.access;

  const res = await fetch(OPENSKY_TOKEN_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({ grant_type: 'client_credentials', client_id: id, client_secret: secret }),
    signal: AbortSignal.timeout(8000),
  });
  if (!res.ok) throw new Error(`OpenSky token ${res.status}`);
  const json = await res.json();
  // Refresh 30s before expiry to avoid edge-of-window 401s.
  token = { access: json.access_token, exp: Date.now() + (json.expires_in - 30) * 1000 };
  return token.access;
}

function buildMeta(status, bbox, extra = {}) {
  return {
    status,
    bbox,
    updatedAt: new Date().toISOString(),
    ...extra,
  };
}

function parseBbox(query) {
  const { lamin, lomin, lamax, lomax } = query;
  const nums = [lamin, lomin, lamax, lomax].map(Number);
  if (nums.some(isNaN)) return null;
  const [la1, lo1, la2, lo2] = nums;
  if (la1 >= la2 || lo1 >= lo2) return null;

  const latSpan = la2 - la1;
  const lonSpan = lo2 - lo1;
  if (latSpan > MAX_LAT_SPAN || lonSpan > MAX_LON_SPAN) return null;

  return { lamin: la1, lomin: lo1, lamax: la2, lomax: lo2 };
}

async function fetchOpenSky(bbox) {
  const params = new URLSearchParams({
    lamin: bbox.lamin,
    lomin: bbox.lomin,
    lamax: bbox.lamax,
    lomax: bbox.lomax,
  });
  const headers = { 'Accept': 'application/json' };
    const access = await getOpenSkyToken();
    if (access) {
      headers['Authorization'] = `Bearer ${access}`;
    }
    const res = await fetch(`${OPENSKY_BASE}/states/all?${params}`, {
      signal: AbortSignal.timeout(8000),
      headers,
    });
    if (!res.ok) throw new Error(`OpenSky ${res.status}`);
    const json = await res.json();

    const states = (json.states ?? []).map(s => ({
      icao24:    s[0],
      callsign:  (s[1] ?? '').trim(),
      origin:    s[2],
      lastSeen:  s[4],
      lon:       s[5],
      lat:       s[6],
      altitude:  s[7] ? Math.round(s[7] * 3.28084) : null, // metres → feet
      onGround:  s[8],
      velocity:  s[9] ? Math.round(s[9] * 1.94384) : null, // m/s → knots
      heading:   s[10] ? Math.round(s[10]) : null,
      vertRate:  s[11],
    })).filter(f =>
      f.lat !== null &&
      f.lon !== null &&
      !f.onGround &&
      (f.altitude === null || f.altitude >= MIN_ALTITUDE_FT)
    );

    return {
      source: 'opensky',
      states,
      count: states.length,
      noFlights: states.length === 0,
      meta: buildMeta('live', bbox),
    };
}

export default async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const bbox = parseBbox(req.query);
  if (!bbox) {
    return res.status(400).json({
      error: `Invalid bbox: provide lamin, lomin, lamax, lomax (max span ${MAX_LAT_SPAN}° lat × ${MAX_LON_SPAN}° lon)`,
    });
  }

  const cacheKey = `${bbox.lamin},${bbox.lomin},${bbox.lamax},${bbox.lomax}`;
  const now = Date.now();
  const hit = cache.get(cacheKey);

  if (hit && now - hit.ts < CACHE_TTL) {
    res.setHeader('Cache-Control', 'public, s-maxage=60, stale-while-revalidate=120');
    res.setHeader('X-Cache', 'HIT');
    return res.status(200).json({
      ...hit.data,
      meta: buildMeta('cache', bbox, { cached: true, cacheAgeMs: now - hit.ts }),
    });
  }

  let result;
  try {
    result = await fetchOpenSky(bbox);
  } catch (openSkyErr) {
    console.error('OpenSky failed:', openSkyErr.message);
    if (hit) {
      res.setHeader('Cache-Control', 'public, s-maxage=60, stale-while-revalidate=120');
      res.setHeader('X-Cache', 'STALE');
      return res.status(200).json({
        ...hit.data,
        meta: buildMeta('stale', bbox, {
          cached: true,
          degraded: true,
          cacheAgeMs: now - hit.ts,
          warning: 'OpenSky unavailable; serving stale flight data',
        }),
      });
    }
    // No cache, no fallback — return empty with error flag
    return res.status(200).json({
      source: 'opensky',
      states: [],
      count: 0,
      noFlights: true,
      meta: buildMeta('error', bbox, {
        degraded: true,
        warning: 'OpenSky unavailable; no flight data',
        detail: openSkyErr.message,
      }),
    });
  }

  cache.set(cacheKey, { data: result, ts: now });
  res.setHeader('Cache-Control', 'public, s-maxage=60, stale-while-revalidate=120');
  res.setHeader('X-Cache', 'MISS');
  return res.status(200).json(result);
}
