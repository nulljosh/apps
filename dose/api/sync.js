import { kv } from '@vercel/kv';

const DATA_KEY = 'dose:userdata';

function unauthorized(res) {
  return res.status(401).json({ error: 'unauthorized' });
}

function authenticate(req) {
  const token = process.env.DOSE_SYNC_TOKEN;
  if (!token) return false;
  const auth = req.headers.authorization;
  if (!auth?.startsWith('Bearer ')) return false;
  return auth.slice(7) === token;
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, PUT, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (!authenticate(req)) return unauthorized(res);

  if (req.method === 'GET') {
    const data = await kv.get(DATA_KEY);
    return res.status(200).json(data || { log: [], substances: [], biometrics: [], profile: {}, medications: [] });
  }

  if (req.method === 'PUT') {
    const body = req.body;
    if (!body || typeof body !== 'object') {
      return res.status(400).json({ error: 'invalid body' });
    }

    // Merge strategy: client sends full state, server stores it
    // Last-write-wins with timestamp
    const payload = {
      log: body.log || [],
      substances: body.substances || [],
      biometrics: body.biometrics || [],
      profile: body.profile || {},
      medications: body.medications || [],
      updatedAt: new Date().toISOString(),
    };

    await kv.set(DATA_KEY, payload);
    return res.status(200).json({ ok: true, updatedAt: payload.updatedAt });
  }

  return res.status(405).json({ error: 'method not allowed' });
}
