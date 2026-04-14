const PARTS_KEY = 'garage_parts';
const HISTORY_KEY = 'garage_history';
const SEED_VERSION = 'garage_seed_v3';

export function getParts() {
  try {
    // Force re-seed when version changes (clears old demo data)
    if (!localStorage.getItem(SEED_VERSION)) {
      localStorage.removeItem(PARTS_KEY);
      localStorage.removeItem(HISTORY_KEY);
      localStorage.removeItem('garage_seeded');
      localStorage.setItem(SEED_VERSION, '1');
      saveParts(REAL_INVENTORY);
      return [...REAL_INVENTORY];
    }
    const stored = JSON.parse(localStorage.getItem(PARTS_KEY));
    if (stored && stored.length > 0) return stored;
    saveParts(REAL_INVENTORY);
    return [...REAL_INVENTORY];
  } catch {
    return [];
  }
}

export function saveParts(parts) {
  localStorage.setItem(PARTS_KEY, JSON.stringify(parts));
}

export function getHistory() {
  try {
    return JSON.parse(localStorage.getItem(HISTORY_KEY)) || [];
  } catch {
    return [];
  }
}

export function addHistory(entry) {
  const history = getHistory();
  history.unshift({ ...entry, timestamp: Date.now() });
  if (history.length > 500) history.length = 500;
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
}

export function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

export const CATEGORIES = [
  'Springs',
  'Rollers',
  'Hardware',
  'Remotes',
  'Weatherstripping',
  'Power',
];

const SETTINGS_KEY = 'garage_settings';

export function getSettings() {
  try {
    return JSON.parse(localStorage.getItem(SETTINGS_KEY)) || {
      alertEmail: 'expert@bcgaragedoors.ca',
      alertsEnabled: true,
    };
  } catch {
    return { alertEmail: 'expert@bcgaragedoors.ca', alertsEnabled: true };
  }
}

export function saveSettings(settings) {
  localStorage.setItem(SETTINGS_KEY, JSON.stringify(settings));
}

export function buildReorderMailto(part, alertEmail) {
  const to = alertEmail || '';
  const subject = encodeURIComponent(`Reorder: ${part.name} (${part.sku})`);
  const body = encodeURIComponent(
    `Low stock alert for Best Choice Garage Doors:\n\n` +
    `Part: ${part.name}\n` +
    `SKU: ${part.sku}\n` +
    `Category: ${part.category}\n` +
    `Current Stock: ${part.quantity}\n` +
    `Minimum Threshold: ${part.minThreshold}\n` +
    `Supplier: ${part.supplier || 'Not specified'}\n\n` +
    `Please reorder this item.`
  );
  return `mailto:${to}?subject=${subject}&body=${body}`;
}

// ---- PIN ----

export function getPin() { return localStorage.getItem('garage_pin'); }
export function setPin(pin) {
  if (!pin) { localStorage.removeItem('garage_pin'); return; }
  localStorage.setItem('garage_pin', pin);
}
export function checkPin(input) { return input === getPin(); }

// ---- Jobs ----

const JOBS_KEY = 'garage_jobs';
export const JOB_STATUSES = ['Lead', 'Quote', 'Scheduled', 'Complete', 'Paid'];

export function getJobs() {
  try { return JSON.parse(localStorage.getItem(JOBS_KEY)) || []; } catch { return []; }
}
export function saveJobs(jobs) { localStorage.setItem(JOBS_KEY, JSON.stringify(jobs)); }

// ---- Backup / Restore ----

export function exportAll() {
  return JSON.stringify({
    parts: getParts(),
    history: getHistory(),
    settings: getSettings(),
    jobs: getJobs(),
    exportedAt: new Date().toISOString(),
  });
}

export function importAll(jsonStr) {
  const data = JSON.parse(jsonStr);
  if (data.parts) saveParts(data.parts);
  if (data.history) localStorage.setItem(HISTORY_KEY, JSON.stringify(data.history));
  if (data.settings) saveSettings(data.settings);
  if (data.jobs) saveJobs(data.jobs);
}

export const REAL_INVENTORY = [
  // Springs -- color-coded by wire gauge, red/black cone ends
  { id: 'r01', name: 'Torsion Spring - Yellow / Red', sku: 'SPR-YLW-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 35, supplier: '' },
  { id: 'r02', name: 'Torsion Spring - Yellow / Black', sku: 'SPR-YLW-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 35, supplier: '' },
  { id: 'r03', name: 'Torsion Spring - White / Red', sku: 'SPR-WHT-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 38, supplier: '' },
  { id: 'r04', name: 'Torsion Spring - White / Black', sku: 'SPR-WHT-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 38, supplier: '' },
  { id: 'r05', name: 'Torsion Spring - Red / Red', sku: 'SPR-RED-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 42, supplier: '' },
  { id: 'r06', name: 'Torsion Spring - Red / Black', sku: 'SPR-RED-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 42, supplier: '' },
  { id: 'r07', name: 'Torsion Spring - Brown / Red', sku: 'SPR-BRN-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 40, supplier: '' },
  { id: 'r08', name: 'Torsion Spring - Brown / Black', sku: 'SPR-BRN-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 40, supplier: '' },
  { id: 'r09', name: 'Torsion Spring - Green / Red', sku: 'SPR-GRN-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 45, supplier: '' },
  { id: 'r10', name: 'Torsion Spring - Green / Black', sku: 'SPR-GRN-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 45, supplier: '' },
  { id: 'r11', name: 'Torsion Spring - Gold / Red', sku: 'SPR-GLD-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 48, supplier: '' },
  { id: 'r12', name: 'Torsion Spring - Gold / Black', sku: 'SPR-GLD-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 48, supplier: '' },
  { id: 'r13', name: 'Torsion Spring - Blue / Red', sku: 'SPR-BLU-RED', category: 'Springs', quantity: 2, minThreshold: 1, cost: 50, supplier: '' },
  { id: 'r14', name: 'Torsion Spring - Blue / Black', sku: 'SPR-BLU-BLK', category: 'Springs', quantity: 2, minThreshold: 1, cost: 50, supplier: '' },

  // Rollers
  { id: 'r15', name: 'Nylon Rollers (half bucket)', sku: 'ROL-NYL-STD', category: 'Rollers', quantity: 75, minThreshold: 20, cost: 2.50, supplier: '' },

  // Remotes & Keypads
  { id: 'r16', name: 'LiftMaster 979LM Keypad', sku: 'RMT-979LM', category: 'Remotes', quantity: 5, minThreshold: 2, cost: 45, supplier: 'LiftMaster' },
  { id: 'r17', name: 'LiftMaster 992LM Remote', sku: 'RMT-992LM', category: 'Remotes', quantity: 4, minThreshold: 2, cost: 35, supplier: 'LiftMaster' },
  { id: 'r18', name: 'LiftMaster 387LM Keypad', sku: 'RMT-387LM', category: 'Remotes', quantity: 2, minThreshold: 1, cost: 50, supplier: 'LiftMaster' },
  { id: 'r19', name: 'LiftMaster 6580LM', sku: 'RMT-6580LM', category: 'Remotes', quantity: 6, minThreshold: 2, cost: 40, supplier: 'LiftMaster' },

  // Hardware
  { id: 'r20', name: 'Gear and Sprocket Kit', sku: 'HDW-GNS-KIT', category: 'Hardware', quantity: 13, minThreshold: 4, cost: 25, supplier: '' },
  { id: 'r21', name: 'Full Section Operator Bracket', sku: 'HDW-FSO-BKT', category: 'Hardware', quantity: 8, minThreshold: 3, cost: 18, supplier: '' },
  { id: 'r22', name: 'Hinge #2', sku: 'HDW-HNG-002', category: 'Hardware', quantity: 20, minThreshold: 6, cost: 4.50, supplier: '' },
  { id: 'r23', name: 'Hinge #3', sku: 'HDW-HNG-003', category: 'Hardware', quantity: 14, minThreshold: 6, cost: 5, supplier: '' },
  { id: 'r24', name: 'Hinge #4', sku: 'HDW-HNG-004', category: 'Hardware', quantity: 20, minThreshold: 6, cost: 5.50, supplier: '' },

  // Power
  { id: 'r25', name: 'Backup Battery (LiftMaster 485LM)', sku: 'PWR-485LM', category: 'Power', quantity: 2, minThreshold: 2, cost: 30, supplier: 'LiftMaster' },
  { id: 'r26', name: 'CR2032 Battery', sku: 'PWR-CR2032', category: 'Power', quantity: 16, minThreshold: 5, cost: 0.75, supplier: '' },

  // Weatherstripping
  { id: 'r27', name: 'Wood Door Bottom Rubber (roll)', sku: 'WTR-WDB-ROL', category: 'Weatherstripping', quantity: 1, minThreshold: 1, cost: 35, supplier: '' },
  { id: 'r28', name: 'Steel Craft Bottom Rubber (half roll)', sku: 'WTR-SCR-HLF', category: 'Weatherstripping', quantity: 1, minThreshold: 1, cost: 28, supplier: '' },
];
