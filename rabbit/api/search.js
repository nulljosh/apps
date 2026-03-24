export default async function handler(req, res) {
  const allowedOrigins = ['https://rabbit-lyart.vercel.app', 'http://localhost:3000', 'http://localhost:5173'];
  const origin = req.headers.origin;
  if (allowedOrigins.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  const { q, limit = '20' } = req.query;

  if (!q || !q.trim()) {
    return res.status(400).json({ error: 'Missing query parameter q' });
  }

  const query = q.trim();
  const maxResults = Math.min(parseInt(limit, 10) || 20, 50);

  const { results, engine } = await trySearch(query, maxResults + 10);

  if (!results) {
    return res.status(503).json({
      error: 'All search engines unavailable',
      engines_tried: ['searxng', 'duckduckgo', 'brave'],
    });
  }

  const cleaned = postProcessResults(results, maxResults);
  return res.status(200).json({ results: cleaned, query, engine });
}

async function trySearch(query, limit) {
  const engines = [
    { name: 'searxng', fn: () => searchSearXNG(query, limit) },
    { name: 'duckduckgo', fn: () => searchDuckDuckGo(query, limit) },
    { name: 'brave', fn: () => searchBrave(query, limit) },
  ];

  for (const engine of engines) {
    try {
      const results = await engine.fn();
      if (results && results.length > 0) {
        console.log(`Search succeeded via ${engine.name}: ${results.length} results`);
        return { results, engine: engine.name };
      }
      console.log(`Engine ${engine.name} returned 0 results, trying next`);
    } catch (err) {
      console.error(`Engine ${engine.name} failed: ${err.message}`);
    }
  }

  return { results: null, engine: null };
}

async function searchSearXNG(query, limit) {
  const instances = [
    'https://searx.be',
    'https://search.ononoki.org',
    'https://searx.tiekoetter.com',
  ];

  for (const instance of instances) {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 5000);

      const params = new URLSearchParams({ q: query, format: 'json', categories: 'general' });
      const url = `${instance}/search?${params.toString()}`;

      const response = await fetch(url, {
        signal: controller.signal,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'application/json',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      });

      clearTimeout(timeout);

      if (response.status === 429) {
        console.log(`SearXNG instance ${instance} returned 429, trying next`);
        continue;
      }

      if (!response.ok) {
        console.log(`SearXNG instance ${instance} returned HTTP ${response.status}, trying next`);
        continue;
      }

      const data = await response.json();

      if (!data.results || !Array.isArray(data.results)) {
        console.log(`SearXNG instance ${instance} returned no results array, trying next`);
        continue;
      }

      const results = [];
      for (const item of data.results.slice(0, limit)) {
        try {
          new URL(item.url);
        } catch (_) {
          continue;
        }
        results.push({
          title: stripHtml(item.title || 'Untitled'),
          url: item.url,
          snippet: stripHtml(item.content || item.description || ''),
        });
      }

      if (results.length > 0) return results;
      console.log(`SearXNG instance ${instance} parsed 0 valid results, trying next`);
    } catch (err) {
      if (err.name === 'AbortError') {
        console.log(`SearXNG instance ${instance} timed out`);
      } else {
        console.log(`SearXNG instance ${instance} error: ${err.message}`);
      }
    }
  }

  throw new Error('All SearXNG instances failed');
}

async function searchDuckDuckGo(query, limit) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);

  const params = new URLSearchParams({ q: query, kl: 'us-en' });
  const url = `https://lite.duckduckgo.com/lite/?${params.toString()}`;

  const response = await fetch(url, {
    signal: controller.signal,
    headers: {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.5',
      'Referer': 'https://lite.duckduckgo.com/',
      'DNT': '1',
      'Connection': 'keep-alive',
      'Upgrade-Insecure-Requests': '1',
    },
  });

  clearTimeout(timeout);

  if (response.status === 429) {
    throw new Error('DuckDuckGo returned 429');
  }

  if (!response.ok) {
    throw new Error(`DuckDuckGo returned HTTP ${response.status}`);
  }

  const html = await response.text();

  if (/please try again|robot|captcha/i.test(html)) {
    throw new Error('DuckDuckGo CAPTCHA detected');
  }

  return parseDDGResults(html, limit);
}

function parseDDGResults(html, limit) {
  const results = [];
  const linkRegex = /<a[^>]+class="result-link"[^>]+href="([^"]+)"[^>]*>([\s\S]*?)<\/a>/gi;
  const snippetRegex = /<td[^>]+class="result-snippet"[^>]*>([\s\S]*?)<\/td>/gi;

  let linkMatch;
  while ((linkMatch = linkRegex.exec(html)) !== null && results.length < limit) {
    const rawUrl = linkMatch[1];
    const rawTitle = linkMatch[2];

    if (rawUrl.startsWith('//duckduckgo.com') || rawUrl.startsWith('/?')) continue;
    const cleanUrl = decodeDDGUrl(rawUrl);
    try { new URL(cleanUrl); } catch (_) { continue; }

    const title = stripHtml(rawTitle).trim();
    if (!title) continue;

    snippetRegex.lastIndex = linkMatch.index + linkMatch[0].length;
    const snippetMatch = snippetRegex.exec(html);
    const snippet = snippetMatch ? stripHtml(snippetMatch[1]).trim() : '';

    results.push({ title, url: cleanUrl, snippet });
  }

  return results;
}

function decodeDDGUrl(raw) {
  try {
    if (raw.includes('uddg=')) {
      const match = raw.match(/uddg=([^&]+)/);
      if (match) return decodeURIComponent(match[1]);
    }
    if (raw.startsWith('http')) return raw;
    if (raw.startsWith('//')) return `https:${raw}`;
    return raw;
  } catch (_) {
    return raw;
  }
}

async function searchBrave(query, limit) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 5000);

  const params = new URLSearchParams({ q: query });
  const url = `https://search.brave.com/search?${params.toString()}`;

  const response = await fetch(url, {
    signal: controller.signal,
    headers: {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Language': 'en-US,en;q=0.9',
      'Referer': 'https://search.brave.com/',
      'DNT': '1',
    },
  });

  clearTimeout(timeout);

  if (response.status === 429) {
    throw new Error('Brave returned 429');
  }

  if (!response.ok) {
    throw new Error(`Brave returned HTTP ${response.status}`);
  }

  const html = await response.text();
  return parseBraveResults(html, limit);
}

function parseBraveResults(html, limit) {
  const results = [];

  // Each result lives in a data-type="web" block
  const blockRegex = /<div[^>]+data-type="web"[^>]*>([\s\S]*?)(?=<div[^>]+data-type="web"|<footer|$)/gi;
  let blockMatch;
  const blocks = [];

  while ((blockMatch = blockRegex.exec(html)) !== null) {
    blocks.push(blockMatch[1]);
  }

  // Fallback: split on snippet fenced regions if data-type not found
  if (blocks.length === 0) {
    const fallbackRegex = /<div[^>]+class="[^"]*snippet[^"]*"[^>]*>([\s\S]*?)(?=<div[^>]+class="[^"]*snippet[^"]*"|<footer|$)/gi;
    while ((blockMatch = fallbackRegex.exec(html)) !== null) {
      blocks.push(blockMatch[1]);
    }
  }

  for (const block of blocks.slice(0, limit)) {
    // Find first external link as the result URL + title
    const linkMatch = block.match(/<a[^>]+href="(https?:\/\/(?!search\.brave\.com)[^"]+)"[^>]*>([\s\S]*?)<\/a>/i);
    if (!linkMatch) continue;

    const url = linkMatch[1];
    try { new URL(url); } catch (_) { continue; }

    // Title: prefer the page-title heading (class containing "title"), fall back to link text
    // Brave wraps the actual title in a element with class like "title" or "heading"
    const titleClassMatch = block.match(/<[^>]+class="[^"]*(?:title|heading)[^"]*"[^>]*>([\s\S]*?)<\/[^>]+>/i);
    let rawTitle = titleClassMatch ? stripHtml(titleClassMatch[1]).trim() : '';

    // If that failed, try h1-h4 but pick the LONGEST one (not first — first is often breadcrumb)
    if (!rawTitle || rawTitle.length < 5) {
      const allHeadings = [...block.matchAll(/<(?:h[1-4])[^>]*>([\s\S]*?)<\/(?:h[1-4])>/gi)];
      if (allHeadings.length > 0) {
        rawTitle = allHeadings.map(m => stripHtml(m[1]).trim()).sort((a, b) => b.length - a.length)[0] || '';
      }
    }

    // Fall back to link text
    if (!rawTitle || rawTitle.length < 5) {
      rawTitle = stripHtml(linkMatch[2]).trim();
    }

    const title = rawTitle;
    if (!title) continue;

    // Snippet: longest text node in a <p> or description-like element
    const descMatches = [...block.matchAll(/<p[^>]*>([\s\S]*?)<\/p>/gi)];
    let snippet = '';
    for (const m of descMatches) {
      const text = stripHtml(m[1]).trim();
      if (text.length > snippet.length) snippet = text;
    }

    results.push({ title, url, snippet });
  }

  return results;
}

function stripHtml(html) {
  return html
    .replace(/<[^>]+>/g, '')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/&nbsp;/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

const GENERIC_TITLES = new Set(['home', 'index', 'page', 'default', 'main', 'welcome', 'untitled']);

function cleanTitle(rawTitle, url) {
  let title = rawTitle;

  // Strip breadcrumb prefixes: "› path › to › Page Title" -> keep longest segment
  if (title.includes('›')) {
    const parts = title.split('›').map(s => s.trim()).filter(Boolean);
    // Pick longest segment — breadcrumbs are short, real titles are longer
    const longest = parts.sort((a, b) => b.length - a.length)[0] || title;
    if (longest.length >= 5) title = longest;
  }

  // Replace underscores with spaces (wiki-style URLs used as titles)
  title = title.replace(/_/g, ' ');

  // Strip trailing file extensions (only if title has no spaces -- looks like a filename)
  if (!title.includes(' ')) {
    title = title.replace(/\.\w{2,4}$/, '');
  }

  // Dehyphenate URL slugs (3+ hyphens with no spaces = slug)
  if ((title.match(/-/g) || []).length >= 3 && !title.includes(' ')) {
    title = title.replace(/-/g, ' ');
  }

  // If title is generic or too short, derive from URL
  const isGeneric = GENERIC_TITLES.has(title.toLowerCase().trim());
  if ((!title || title.length < 3 || isGeneric) && url) {
    try {
      const u = new URL(url);
      const segments = u.pathname.split('/').filter(Boolean);
      if (segments.length > 0) {
        const last = segments[segments.length - 1] || '';
        title = decodeURIComponent(last).replace(/[-_]/g, ' ').replace(/\.\w+$/, '');
      } else {
        // Use domain name as title for homepages
        title = u.hostname.replace(/^www\./, '').split('.')[0];
        title = title.charAt(0).toUpperCase() + title.slice(1);
      }
    } catch (_) {}
  }

  return title.trim() || rawTitle;
}

function extractDomain(url) {
  try { return new URL(url).hostname.replace(/^www\./, ''); } catch (_) { return null; }
}

function postProcessResults(results, limit) {
  const domainCount = {};
  const out = [];
  for (const r of results) {
    if (out.length >= limit) break;
    const title = cleanTitle(r.title, r.url);
    if (!title || title.length <= 1) continue;
    const domain = extractDomain(r.url);
    if (domain) {
      domainCount[domain] = (domainCount[domain] || 0) + 1;
      if (domainCount[domain] > 2) continue;
    }
    out.push({ ...r, title });
  }
  return out;
}
