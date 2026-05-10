const rateLimitStore = new Map();
const RATE_WINDOW_MS = 60_000;
const RATE_LIMIT = 20;

function checkRateLimit(ip) {
  const now = Date.now();
  const entry = rateLimitStore.get(ip);
  if (!entry || now - entry.start > RATE_WINDOW_MS) {
    rateLimitStore.set(ip, { start: now, count: 1 });
    return true;
  }
  if (entry.count >= RATE_LIMIT) return false;
  entry.count++;
  return true;
}

export default async function handler(req, res) {
  const allowedOrigins = ['https://nimble.heyitsmejosh.com', 'http://localhost:3000', 'http://localhost:5173'];
  const origin = req.headers.origin;
  if (allowedOrigins.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const ip = req.headers['x-forwarded-for']?.split(',')[0]?.trim() || req.socket?.remoteAddress || 'unknown';
  if (!checkRateLimit(ip)) {
    return res.status(429).json({ error: 'Too many requests' });
  }

  const { q } = req.query;
  if (!q || !q.trim()) return res.status(400).json({ error: 'Missing query parameter q' });

  const query = q.trim();
  const { ddgQuery, wikiQuery } = preprocessQuery(query);
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);

  try {
    const [ddg, wiki] = await Promise.allSettled([
      queryDDG(ddgQuery, controller.signal),
      queryWikipedia(wikiQuery, controller.signal),
    ]);

    clearTimeout(timeout);

    if (ddg.status === 'fulfilled' && ddg.value) {
      return res.status(200).json(ddg.value);
    }
    if (wiki.status === 'fulfilled' && wiki.value) {
      return res.status(200).json(wiki.value);
    }

    return res.status(200).json({ type: null });
  } catch {
    clearTimeout(timeout);
    return res.status(200).json({ type: null });
  }
}

async function queryDDG(query, signal) {
  const url = `https://api.duckduckgo.com/?q=${encodeURIComponent(query)}&format=json&no_html=1&skip_disambig=1`;
  const res = await fetch(url, { signal, headers: { 'User-Agent': 'Nimble/3.0' } });
  if (!res.ok) return null;

  const data = await res.json();

  if (data.Answer) {
    const clean = data.Answer.replace(/<[^>]+>/g, '');
    if (clean) {
      return {
        type: 'text',
        heading: null,
        body: clean,
        source: 'DuckDuckGo',
        sourceURL: null,
        imageURL: null,
      };
    }
  }

  if (data.Definition) {
    return {
      type: 'text',
      heading: data.Heading || null,
      body: data.Definition,
      source: data.DefinitionSource || 'DuckDuckGo',
      sourceURL: data.DefinitionURL || null,
      imageURL: null,
    };
  }

  if (data.AbstractText) {
    return {
      type: 'text',
      heading: data.Heading || null,
      body: data.AbstractText,
      source: data.AbstractSource || 'DuckDuckGo',
      sourceURL: data.AbstractURL || null,
      imageURL: data.Image ? `https://duckduckgo.com${data.Image}` : null,
    };
  }

  if (data.RelatedTopics && data.RelatedTopics.length > 0) {
    const items = [];
    for (const topic of data.RelatedTopics.slice(0, 5)) {
      if (topic.Text) items.push(topic.Text);
      if (topic.Topics) {
        for (const sub of topic.Topics.slice(0, 2)) {
          if (sub.Text) items.push(sub.Text);
        }
      }
    }
    if (items.length > 0) {
      return { type: 'list', items, source: 'DuckDuckGo' };
    }
  }

  return null;
}

async function queryWikipedia(query, signal) {
  const title = query.replace(/ /g, '_');
  const encoded = encodeURIComponent(title);
  const summaryURL = `https://en.wikipedia.org/api/rest_v1/page/summary/${encoded}`;

  const summary = await fetchWikiSummary(summaryURL, signal);
  if (summary) return summary;

  const searchURL = `https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(query)}&format=json&srlimit=1`;
  try {
    const res = await fetch(searchURL, { signal, headers: { 'User-Agent': 'Nimble/3.0' } });
    if (!res.ok) return null;
    const data = await res.json();
    const first = data?.query?.search?.[0];
    if (!first) return null;

    const articleTitle = first.title.replace(/ /g, '_');
    return await fetchWikiSummary(
      `https://en.wikipedia.org/api/rest_v1/page/summary/${encodeURIComponent(articleTitle)}`,
      signal
    );
  } catch {
    return null;
  }
}

function preprocessQuery(raw) {
  let q = raw.trim().replace(/\?+$/, '').trim();

  // "who is [the] X" / "who was [the] X"
  let m = q.match(/^who\s+(?:is|was|are|were)\s+(?:the\s+)?(.+)$/i);
  if (m) return { ddgQuery: m[1].trim(), wikiQuery: m[1].trim() };

  // "what is [the] X" / "what's [the] X"
  m = q.match(/^what(?:'s|\s+is|\s+was)\s+(?:the\s+)?(.+)$/i);
  if (m) return { ddgQuery: m[1].trim(), wikiQuery: m[1].trim() };

  // "where is X [located]"
  m = q.match(/^where\s+is\s+(.+?)(?:\s+located)?$/i);
  if (m) return { ddgQuery: `${m[1].trim()} location`, wikiQuery: m[1].trim() };

  // "when was/did X [born/founded]"
  m = q.match(/^when\s+(?:was|did|were?|is)\s+(.+?)(?:\s+born|\s+founded|\s+established)?$/i);
  if (m) return { ddgQuery: raw, wikiQuery: m[1].trim() };

  // "how [adj] is X"
  m = q.match(/^how\s+(much|many|tall|old|big|far|long|wide|deep|large|small|fast|heavy)\s+is\s+(.+)$/i);
  if (m) return { ddgQuery: `${m[2].trim()} ${m[1].toLowerCase()}`, wikiQuery: m[2].trim() };

  // "population/capital/president/prime minister/currency/language/area of X"
  m = q.match(/^(population|capital|president|prime\s+minister|premier|currency|language|area|gdp|timezone)\s+of\s+(.+)$/i);
  if (m) return { ddgQuery: `${m[2].trim()} ${m[1].toLowerCase()}`, wikiQuery: `${m[1].toLowerCase()} of ${m[2].trim()}` };

  return { ddgQuery: raw, wikiQuery: raw };
}

async function fetchWikiSummary(url, signal) {
  try {
    const res = await fetch(url, { signal, headers: { 'User-Agent': 'Nimble/3.0' } });
    if (res.status !== 200) return null;
    const data = await res.json();
    if (!data.extract) return null;

    return {
      type: 'text',
      heading: data.title || null,
      body: data.extract,
      source: 'Wikipedia',
      sourceURL: data.content_urls?.desktop?.page || null,
      imageURL: data.thumbnail?.source || null,
    };
  } catch {
    return null;
  }
}
