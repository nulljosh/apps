export default async function handler(req, res) {
  const allowedOrigins = ['https://nimble.heyitsmejosh.com', 'http://localhost:3000', 'http://localhost:5173'];
  const origin = req.headers.origin;
  if (allowedOrigins.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();

  const { q } = req.query;
  if (!q || !q.trim()) return res.status(400).json({ error: 'Missing query parameter q' });

  const query = q.trim();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);

  try {
    const [ddg, wiki] = await Promise.allSettled([
      queryDDG(query, controller.signal),
      queryWikipedia(query, controller.signal),
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
