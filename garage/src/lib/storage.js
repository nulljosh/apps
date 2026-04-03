const PARTS_KEY = 'garage_parts';
const HISTORY_KEY = 'garage_history';

export function getParts() {
  try {
    return JSON.parse(localStorage.getItem(PARTS_KEY)) || [];
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
  'Openers',
  'Panels',
  'Hardware',
  'Remotes',
  'Weatherstripping',
];
