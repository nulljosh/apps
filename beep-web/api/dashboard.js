const fetch = require('node-fetch');
const cheerio = require('cheerio');

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Authorization');
  if (req.method === 'OPTIONS') return res.status(200).end();

  const token = (req.headers['authorization'] || '').replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'No token' });

  let cookies;
  try { cookies = JSON.parse(Buffer.from(token, 'base64').toString()); }
  catch { return res.status(401).json({ error: 'Invalid token' }); }

  const UA = 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15';

  try {
    const r = await fetch('https://www.compasscard.ca/', {
      headers: { 'Cookie': cookieStr(cookies), 'User-Agent': UA }
    });

    if (r.url.toLowerCase().includes('signin')) {
      return res.status(401).json({ error: 'Session expired' });
    }

    const $ = cheerio.load(await r.text());

    // Balance — same heuristics as BeepExtractor.cardInfoJSON
    let balance = null;
    $('*').each((_, el) => {
      if (balance) return false;
      const $el = $(el);
      if ($el.children().length) return;
      const text = $el.text().trim();
      const cls = ($el.attr('class') || '').toLowerCase();
      const id  = ($el.attr('id') || '').toLowerCase();
      if (cls.includes('balance') || id.includes('balance') || cls.includes('stored') || id.includes('stored')) {
        const m = text.match(/\$[\d,]+\.\d{2}/);
        if (m) balance = m[0];
      }
    });

    if (!balance) {
      $('*').not('script').each((_, el) => {
        if (balance) return false;
        const $el = $(el);
        if ($el.children().length) return;
        const m = $el.text().trim().match(/\$[\d,]+\.\d{2}/);
        if (m) balance = m[0];
      });
    }

    // Card number
    let cardNumber = null;
    $('*').each((_, el) => {
      if (cardNumber) return false;
      const $el = $(el);
      if ($el.children().length) return;
      const text = $el.text().trim();
      const cls = ($el.attr('class') || '').toLowerCase();
      const id  = ($el.attr('id') || '').toLowerCase();
      if ((cls.includes('card') && (cls.includes('number') || cls.includes('num'))) || id.includes('cardnumber')) {
        const m = text.match(/[\d ]{16,20}/);
        if (m) cardNumber = m[0].trim();
      }
    });

    const autoLoad = $('[class*="autoload"]').filter((_, el) => {
      const cls = ($(el).attr('class') || '').toLowerCase();
      return cls.includes('activ') || cls.includes('enabl');
    }).length > 0;

    return res.json({ balance: balance || '--', cardNumber: cardNumber || '', autoLoad });

  } catch (err) {
    console.error('dashboard:', err);
    return res.status(500).json({ error: 'Failed to load dashboard' });
  }
};

function cookieStr(c) {
  return Object.entries(c).map(([k, v]) => `${k}=${v}`).join('; ');
}
