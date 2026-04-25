/**
 * Usage Store -- localStorage persistence layer.
 * Manages entries and settings with safe JSON serialization.
 */
const UsageStore = (() => {
  const ENTRIES_KEY = 'usage_entries';
  const SETTINGS_KEY = 'usage_settings';

  let _entriesCache = null;

  const defaultSettings = {
    claudeMonthly: 136.60,
    chatgptMonthly: 27.00,
    currency: 'CAD',
    defaultProvider: 'claude'
  };

  function generateId() {
    return crypto.randomUUID
      ? crypto.randomUUID()
      : Date.now().toString(36) + Math.random().toString(36).slice(2, 9);
  }

  function safeGet(key, fallback) {
    try {
      const raw = localStorage.getItem(key);
      if (!raw) return fallback;
      return JSON.parse(raw);
    } catch (err) {
      console.error('UsageStore read error:', err);
      return fallback;
    }
  }

  function safeSet(key, value) {
    try {
      localStorage.setItem(key, JSON.stringify(value));
      return true;
    } catch (err) {
      console.error('UsageStore write error:', err);
      return false;
    }
  }

  function getEntries() {
    if (_entriesCache) return _entriesCache;
    _entriesCache = safeGet(ENTRIES_KEY, []);
    return _entriesCache;
  }

  function saveEntries(entries) {
    _entriesCache = entries;
    return safeSet(ENTRIES_KEY, entries);
  }

  function getSettings() {
    return { ...defaultSettings, ...safeGet(SETTINGS_KEY, {}) };
  }

  function saveSettings(settings) {
    return safeSet(SETTINGS_KEY, settings);
  }

  function addEntry(entry) {
    const entries = getEntries();
    const record = {
      id: generateId(),
      provider: entry.provider || 'claude',
      date: entry.date || new Date().toISOString().slice(0, 10),
      conversations: parseInt(entry.conversations, 10) || 0,
      tokensEstimate: parseInt(entry.tokensEstimate, 10) || 0,
      costEstimate: parseFloat(entry.costEstimate) || 0,
      model: entry.model || '',
      notes: entry.notes || '',
      createdAt: Date.now()
    };
    entries.push(record);
    saveEntries(entries);
    return record;
  }

  function updateEntry(id, updates) {
    const entries = getEntries();
    const idx = entries.findIndex((e) => e.id === id);
    if (idx === -1) return null;
    entries[idx] = { ...entries[idx], ...updates };
    saveEntries(entries);
    return entries[idx];
  }

  function deleteEntry(id) {
    const entries = getEntries().filter((e) => e.id !== id);
    return saveEntries(entries);
  }

  function exportData() {
    return JSON.stringify({
      entries: getEntries(),
      settings: getSettings(),
      exportedAt: new Date().toISOString()
    }, null, 2);
  }

  function importData(jsonString) {
    try {
      const data = JSON.parse(jsonString);
      if (!Array.isArray(data.entries)) {
        throw new Error('Invalid data: entries must be an array');
      }
      saveEntries(data.entries);
      if (data.settings) saveSettings(data.settings);
      return { success: true, count: data.entries.length };
    } catch (err) {
      return { success: false, error: err.message };
    }
  }

  function clearAll() {
    _entriesCache = null;
    localStorage.removeItem(ENTRIES_KEY);
    localStorage.removeItem(SETTINGS_KEY);
  }

  return {
    getEntries,
    getSettings,
    saveSettings,
    addEntry,
    updateEntry,
    deleteEntry,
    exportData,
    importData,
    clearAll,
    generateId
  };
})();
