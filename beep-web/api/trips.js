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
    const r = await fetch('https://www.compasscard.ca/CardUse', {
      headers: { 'Cookie': cookieStr(cookies), 'User-Agent': UA }
    });

    if (r.url.toLowerCase().includes('signin')) {
      return res.status(401).json({ error: 'Session expired' });
    }

    const $ = cheerio.load(await r.text());
    const rows = [];

    $('table tbody tr').each((_, tr) => {
      const cells = $(tr).find('td');
      if (cells.length >= 3) {
        rows.push({
          date:     $(cells[0]).text().trim(),
          location: $(cells[1]).text().trim(),
          product:  $(cells[2]).text().trim(),
          amount:   cells.length > 3 ? $(cells[3]).text().trim() : '',
          balance:  cells.length > 4 ? $(cells[4]).text().trim() : '',
        });
      }
    });

    return res.json(rows);

  } catch (err) {
    console.error('trips:', err);
    return res.status(500).json({ error: 'Failed to load trips' });
  }
};

function cookieStr(c) {
  return Object.entries(c).map(([k, v]) => `${k}=${v}`).join('; ');
}
