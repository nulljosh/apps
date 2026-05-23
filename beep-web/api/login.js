const fetch = require('node-fetch');
const cheerio = require('cheerio');

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).end();

  let email, password;
  try {
    ({ email, password } = JSON.parse(req.body));
  } catch {
    return res.status(400).json({ error: 'Invalid request body' });
  }
  if (!email || !password) return res.status(400).json({ error: 'Missing credentials' });

  const UA = 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1';

  try {
    // GET sign-in page — collect CSRF tokens
    const r1 = await fetch('https://www.compasscard.ca/SignIn', {
      headers: { 'User-Agent': UA, 'Accept': 'text/html' }
    });
    const html1 = await r1.text();
    const cookies1 = parseCookies(r1.headers.raw()['set-cookie'] || []);

    const $ = cheerio.load(html1);

    // Collect all hidden inputs (VIEWSTATE, EVENTVALIDATION, __RequestVerificationToken, etc.)
    const formFields = {};
    $('input[type="hidden"]').each((_, el) => {
      const name = $(el).attr('name');
      if (name) formFields[name] = $(el).attr('value') || '';
    });

    // Find field names dynamically (same selectors as BeepExtractor.fillLogin)
    const $email = $('input[type="email"], input[id*="Email" i], input[name*="Email" i], input[id*="Username" i]').first();
    const $pass  = $('input[type="password"]').first();
    const $btn   = $('input[type="submit"], button[type="submit"]').first();

    if (!$email.length || !$pass.length) {
      return res.status(500).json({ error: 'Login form not found — selectors may need updating' });
    }

    formFields[$email.attr('name')] = email;
    formFields[$pass.attr('name')]  = password;
    if ($btn.attr('name')) formFields[$btn.attr('name')] = $btn.attr('value') || 'Sign In';

    // POST credentials
    const r2 = await fetch('https://www.compasscard.ca/SignIn', {
      method: 'POST',
      redirect: 'manual',
      headers: {
        'User-Agent': UA,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': cookieStr(cookies1),
        'Referer': 'https://www.compasscard.ca/SignIn',
        'Origin': 'https://www.compasscard.ca',
      },
      body: new URLSearchParams(formFields).toString(),
    });

    const location = r2.headers.get('location') || '';
    const cookies2 = parseCookies(r2.headers.raw()['set-cookie'] || []);
    const allCookies = { ...cookies1, ...cookies2 };

    if (r2.status >= 300 && r2.status < 400 && !location.toLowerCase().includes('signin')) {
      const token = Buffer.from(JSON.stringify(allCookies)).toString('base64');
      return res.json({ token });
    }

    // Still on sign-in — extract error message
    const errorHtml = r2.status === 200 ? await r2.text() : '';
    const $err = cheerio.load(errorHtml);
    const msg = $err('.field-validation-error, [class*="error" i], [class*="alert" i]').first().text().trim();
    return res.status(401).json({ error: msg || 'Invalid email or password' });

  } catch (err) {
    console.error('login:', err);
    return res.status(500).json({ error: 'Login failed' });
  }
};

function parseCookies(headers) {
  const out = {};
  for (const h of headers) {
    const [kv] = h.split(';');
    const eq = kv.indexOf('=');
    if (eq > 0) out[kv.slice(0, eq).trim()] = kv.slice(eq + 1).trim();
  }
  return out;
}

function cookieStr(cookies) {
  return Object.entries(cookies).map(([k, v]) => `${k}=${v}`).join('; ');
}
