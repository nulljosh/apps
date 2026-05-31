// Inventory, jobs, customers and leads now live in Supabase (see lib/db.js).
// localStorage is kept only for the local activity log, app settings, and the
// optional secondary PIN lock.
const HISTORY_KEY = 'bcgd_history';
const SETTINGS_KEY = 'bcgd_settings';
const PIN_KEY = 'bcgd_pin';

export const CATEGORIES = [
  'Springs', 'Cables', 'Rollers', 'Hinges', 'Tracks',
  'Openers', 'Remotes & Keypads', 'Panels', 'Weather Strips', 'Hardware', 'Other',
];

export const JOB_STATUSES = ['Scheduled', 'In Progress', 'Done', 'Cancelled'];

export function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2);
}

export function getHistory() {
  try { return JSON.parse(localStorage.getItem(HISTORY_KEY)) || []; }
  catch { return []; }
}

export function addHistory(entry) {
  const history = getHistory();
  history.unshift({ ...entry, timestamp: new Date().toISOString(), id: generateId() });
  if (history.length > 200) history.splice(200);
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
}

export function getSettings() {
  try {
    return JSON.parse(localStorage.getItem(SETTINGS_KEY)) || {
      alertEmail: '',
      alertsEnabled: true,
      alertThreshold: 2,
    };
  } catch {
    return { alertEmail: '', alertsEnabled: true, alertThreshold: 2 };
  }
}

export function saveSettings(settings) {
  localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
}

export function getPin() {
  return localStorage.getItem(PIN_KEY) || '';
}

export function savePin(pin) {
  localStorage.setItem(PIN_KEY, pin);
}

export function buildReorderMailto(part, email) {
  const subject = encodeURIComponent(`Reorder: ${part.name} (${part.sku})`);
  const body = encodeURIComponent(
    `Hi,\n\nPlease quote:\n\nItem: ${part.name}\nSKU: ${part.sku}\nSupplier: ${part.supplier}\nCurrent Qty: ${part.quantity}\nMin Threshold: ${part.minThreshold}\n\nThank you`
  );
  return `mailto:${email || ''}?subject=${subject}&body=${body}`;
}

// Parse a markdown/plain job list into job objects.
// One job per line, fields separated by " | ":
//   - Customer | Service | Status | YYYY-MM-DD | Phone | Notes
// Only Customer is required. Leading "- " or "* " bullets are stripped.
// Status is matched (case-insensitive) against JOB_STATUSES, defaulting to "Scheduled".
export function parseJobsMarkdown(text) {
  const jobs = [];
  for (const raw of text.split('\n')) {
    const line = raw.replace(/^\s*[-*]\s*/, '').trim();
    if (!line || line.startsWith('#')) continue;
    const [customer, service = '', statusRaw = '', date = '', phone = '', ...rest] = line.split('|').map(s => s.trim());
    if (!customer) continue;
    const status = JOB_STATUSES.find(s => s.toLowerCase() === statusRaw.toLowerCase()) || 'Scheduled';
    jobs.push({
      id: generateId(), customer, service, status,
      scheduledAt: /^\d{4}-\d{2}-\d{2}$/.test(date) ? date : '',
      phone, address: '', email: '', notes: rest.join(' | '),
      createdAt: new Date().toISOString(),
    });
  }
  return jobs;
}
