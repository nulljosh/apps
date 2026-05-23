// Unified AI handler — enrich, idea-base, notes
// Routes by ?type= to stay under Vercel Hobby 12-function limit.
const { supabaseRequest } = require('./_lib/supabase');
const { isDaemon } = require('./_lib/store');
const { parseToken } = require('./posts');

// --- enrich ---

async function handleEnrich(req, res) {
  if (req.method === 'GET') {
    if (!isDaemon(req)) return res.status(403).json({ error: 'Forbidden' });
    const rows = await supabaseRequest(
      'posts?select=id,title,content,category,linked_repo&enriched=eq.false&enrichment_requested_at=not.is.null&order=enrichment_requested_at.asc&limit=10',
      { useServiceRole: true }
    );
    return res.status(200).json({ posts: Array.isArray(rows) ? rows : [] });
  }

  if (req.method === 'POST') {
    const user = parseToken(req.headers.authorization, req.headers.cookie);
    if (!user) return res.status(401).json({ error: 'Authentication required' });
    const { id } = req.body || {};
    if (!id) return res.status(400).json({ error: 'id required' });
    await supabaseRequest(`posts?id=eq.${encodeURIComponent(id)}`, {
      method: 'PATCH',
      body: { enrichment_requested_at: new Date().toISOString() },
      useServiceRole: true
    });
    return res.status(200).json({ ok: true });
  }

  if (req.method === 'PATCH') {
    if (!isDaemon(req)) return res.status(403).json({ error: 'Forbidden' });
    const { id, plan, spec } = req.body || {};
    if (!id) return res.status(400).json({ error: 'id required' });
    await supabaseRequest(`posts?id=eq.${encodeURIComponent(id)}`, {
      method: 'PATCH',
      body: {
        enriched: true,
        enrichment_plan: plan || null,
        enrichment_spec: spec || null,
        enrichment_completed_at: new Date().toISOString()
      },
      useServiceRole: true
    });
    return res.status(200).json({ ok: true });
  }

  return res.status(405).json({ error: 'Method not allowed' });
}

// --- idea-base ---

async function handleIdeaBase(req, res) {
  if (req.method === 'GET') {
    if (req.query && req.query.pending === 'true') {
      if (!isDaemon(req)) return res.status(403).json({ error: 'Forbidden' });
      const rows = await supabaseRequest(
        'idea_bases?pending=eq.true&order=created_at.asc&limit=5',
        { useServiceRole: true }
      );
      return res.status(200).json({ ideaBases: Array.isArray(rows) ? rows : [] });
    }
    const rows = await supabaseRequest('idea_bases?order=created_at.desc&limit=50');
    return res.status(200).json({ ideaBases: Array.isArray(rows) ? rows : [] });
  }

  if (req.method === 'POST') {
    const user = parseToken(req.headers.authorization, req.headers.cookie);
    if (!user) return res.status(401).json({ error: 'Authentication required' });
    const { topic, description } = req.body || {};
    if (!topic || typeof topic !== 'string' || topic.length > 200) {
      return res.status(400).json({ error: 'topic required (max 200 chars)' });
    }
    const rows = await supabaseRequest('idea_bases', {
      method: 'POST',
      body: {
        topic,
        description: description || null,
        pending: true,
        created_by: user.userId,
        created_at: new Date().toISOString()
      },
      useServiceRole: true
    });
    const row = Array.isArray(rows) ? rows[0] : rows;
    return res.status(201).json({ ideaBase: row });
  }

  if (req.method === 'PATCH') {
    if (!isDaemon(req)) return res.status(403).json({ error: 'Forbidden' });
    const { id, post_ids } = req.body || {};
    if (!id) return res.status(400).json({ error: 'id required' });
    await supabaseRequest(`idea_bases?id=eq.${encodeURIComponent(id)}`, {
      method: 'PATCH',
      body: { pending: false, post_ids: post_ids || [] },
      useServiceRole: true
    });
    return res.status(200).json({ ok: true });
  }

  return res.status(405).json({ error: 'Method not allowed' });
}

// --- notes ---

async function handleNotes(req, res) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const id = req.query && req.query.id;
  if (!id) return res.status(400).json({ error: 'id required' });

  const rows = await supabaseRequest(
    `posts?id=eq.${encodeURIComponent(id)}&select=id,title,content,category,score,linked_repo,enrichment_plan,enrichment_spec,created_at`
  );

  if (!Array.isArray(rows) || rows.length === 0) {
    return res.status(404).json({ error: 'Post not found' });
  }

  const p = rows[0];
  const lines = [
    `---`,
    `id: ${p.id}`,
    `title: ${p.title}`,
    `category: ${p.category || 'tech'}`,
    `score: ${p.score || 0}`,
    p.linked_repo ? `repo: ${p.linked_repo}` : null,
    `created_at: ${p.created_at}`,
    `---`,
    ``,
    `# ${p.title}`,
    ``,
    p.content,
  ];

  if (p.enrichment_spec) lines.push('', '## Spec', '', p.enrichment_spec);
  if (p.enrichment_plan) lines.push('', '## Plan', '', p.enrichment_plan);

  const markdown = lines.filter(l => l !== null).join('\n');
  res.setHeader('Content-Type', 'text/markdown; charset=utf-8');
  res.setHeader('Content-Disposition', `attachment; filename="spark-${p.id}.md"`);
  return res.status(200).send(markdown);
}

// --- router ---

module.exports = async function handler(req, res) {
  try {
    const type = req.query && req.query.type;
    if (type === 'enrich') return await handleEnrich(req, res);
    if (type === 'idea-base') return await handleIdeaBase(req, res);
    if (type === 'notes') return await handleNotes(req, res);
    return res.status(400).json({ error: 'type required: enrich | idea-base | notes' });
  } catch (err) {
    console.error('[AI]', err.message);
    return res.status(500).json({ error: 'Internal server error' });
  }
};
