const PARTS_KEY = 'bcgd_parts';
const JOBS_KEY = 'bcgd_jobs';
const HISTORY_KEY = 'bcgd_history';
const SETTINGS_KEY = 'bcgd_settings';
const PIN_KEY = 'bcgd_pin';
const SEEDED_KEY = 'bcgd_seeded';

export const CATEGORIES = [
  'Springs', 'Cables', 'Rollers', 'Hinges', 'Tracks',
  'Openers', 'Remotes & Keypads', 'Panels', 'Weather Strips', 'Hardware', 'Other',
];

export const JOB_STATUSES = ['Lead', 'Scheduled', 'In Progress', 'Done', 'Cancelled'];

export function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2);
}

export function getParts() {
  try { return JSON.parse(localStorage.getItem(PARTS_KEY)) || []; }
  catch { return []; }
}

export function saveParts(parts) {
  localStorage.setItem(PARTS_KEY, JSON.stringify(parts));
}

export function getJobs() {
  try { return JSON.parse(localStorage.getItem(JOBS_KEY)) || []; }
  catch { return []; }
}

export function saveJobs(jobs) {
  localStorage.setItem(JOBS_KEY, JSON.stringify(jobs));
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

function p(name, sku, category, quantity, minThreshold, cost, supplier = 'LiftMaster') {
  return { id: generateId(), name, sku, category, quantity, minThreshold, cost, supplier };
}

const SEED_PARTS = [
  // Springs (color = wire gauge; Red suffix = right-wind, Black = left-wind)
  p('Yellow Red Spring', 'SPR-YEL-R', 'Springs', 5, 2, 42.00, 'Doors & Hardware'),
  p('Yellow Black Spring', 'SPR-YEL-B', 'Springs', 5, 2, 42.00, 'Doors & Hardware'),
  p('White Red Spring', 'SPR-WHT-R', 'Springs', 5, 2, 38.00, 'Doors & Hardware'),
  p('White Black Spring', 'SPR-WHT-B', 'Springs', 5, 2, 38.00, 'Doors & Hardware'),
  p('Red Red Spring', 'SPR-RED-R', 'Springs', 4, 2, 44.00, 'Doors & Hardware'),
  p('Red Black Spring', 'SPR-RED-B', 'Springs', 4, 2, 44.00, 'Doors & Hardware'),
  p('Brown Red Spring', 'SPR-BRN-R', 'Springs', 4, 2, 46.00, 'Doors & Hardware'),
  p('Brown Black Spring', 'SPR-BRN-B', 'Springs', 4, 2, 46.00, 'Doors & Hardware'),
  p('Green Red Spring', 'SPR-GRN-R', 'Springs', 4, 2, 48.00, 'Doors & Hardware'),
  p('Green Black Spring', 'SPR-GRN-B', 'Springs', 4, 2, 48.00, 'Doors & Hardware'),
  p('Gold Red Spring', 'SPR-GLD-R', 'Springs', 4, 2, 50.00, 'Doors & Hardware'),
  p('Gold Black Spring', 'SPR-GLD-B', 'Springs', 4, 2, 50.00, 'Doors & Hardware'),
  p('Blue Red Spring', 'SPR-BLU-R', 'Springs', 4, 2, 52.00, 'Doors & Hardware'),
  p('Blue Black Spring', 'SPR-BLU-B', 'Springs', 4, 2, 52.00, 'Doors & Hardware'),
  // Openers & Parts
  p('LiftMaster 6580LM', 'OPN-LM-6580', 'Openers', 6, 2, 0, 'LiftMaster'),
  p('Gear & Sprocket Assembly', 'PRT-LM-GEAR', 'Openers', 13, 4, 28.00, 'LiftMaster'),
  p('Full Section Operator Bracket', 'PRT-LM-FSOB', 'Openers', 8, 3, 22.00, 'LiftMaster'),
  p('Backup Battery', 'PRT-LM-BATT', 'Openers', 2, 1, 45.00, 'LiftMaster'),
  p('2023LM Battery', 'PRT-LM-2023', 'Openers', 16, 5, 18.00, 'LiftMaster'),
  // Remotes & Keypads
  p('979LM Keypad', 'KPD-LM-979', 'Remotes & Keypads', 5, 2, 42.00, 'LiftMaster'),
  p('992LM Remote', 'RMT-LM-992', 'Remotes & Keypads', 4, 2, 38.00, 'LiftMaster'),
  p('387LM Keypad', 'KPD-LM-387', 'Remotes & Keypads', 2, 1, 38.00, 'LiftMaster'),
  // Rollers
  p('Rollers (Half Bucket)', 'ROL-HLF-BKT', 'Rollers', 1, 1, 45.00, 'Doors & Hardware'),
  // Hinges
  p('#2 Hinge', 'HNG-002', 'Hinges', 20, 8, 5.00, 'Doors & Hardware'),
  p('#3 Hinge', 'HNG-003', 'Hinges', 14, 6, 6.00, 'Doors & Hardware'),
  p('#4 Hinge', 'HNG-004', 'Hinges', 20, 8, 7.00, 'Doors & Hardware'),
  // Weather Strips
  p('Wood Bottom Rubber (1 roll)', 'WSD-WD-ROLL', 'Weather Strips', 1, 1, 32.00, 'Doors & Hardware'),
  p('Steelcraft Bottom Rubber (½ roll)', 'WSD-SC-HALF', 'Weather Strips', 1, 1, 22.00, 'Doors & Hardware'),
  p('NWD Bottom Rubber (½ roll)', 'WSD-NW-HALF', 'Weather Strips', 1, 1, 22.00, 'Doors & Hardware'),
  // Hardware
  p('Bottom Corner Brackets (pair)', 'HW-BRK-BTM', 'Hardware', 2, 1, 12.00, 'Doors & Hardware'),
];

// Parse a markdown/plain job list into job objects.
// One job per line, fields separated by " | ":
//   - Customer | Service | Status | YYYY-MM-DD | Phone | Notes
// Only Customer is required. Leading "- " or "* " bullets are stripped.
// Status is matched (case-insensitive) against JOB_STATUSES, defaulting to "Lead".
export function parseJobsMarkdown(text) {
  const jobs = [];
  for (const raw of text.split('\n')) {
    const line = raw.replace(/^\s*[-*]\s*/, '').trim();
    if (!line || line.startsWith('#')) continue;
    const [customer, service = '', statusRaw = '', date = '', phone = '', ...rest] = line.split('|').map(s => s.trim());
    if (!customer) continue;
    const status = JOB_STATUSES.find(s => s.toLowerCase() === statusRaw.toLowerCase()) || 'Lead';
    jobs.push({
      id: generateId(), customer, service, status,
      scheduledAt: /^\d{4}-\d{2}-\d{2}$/.test(date) ? date : '',
      phone, address: '', email: '', notes: rest.join(' | '),
      createdAt: new Date().toISOString(),
    });
  }
  return jobs;
}

export function seedIfEmpty() {
  if (localStorage.getItem(SEEDED_KEY)) return;
  if (getParts().length > 0) { localStorage.setItem(SEEDED_KEY, '1'); return; }
  saveParts(SEED_PARTS);
  localStorage.setItem(SEEDED_KEY, '1');
}
