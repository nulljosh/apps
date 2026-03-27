/**
 * Stats Engine -- aggregation and computation for usage data.
 * Pure functions, no side effects.
 */
const StatsEngine = (() => {

  function toDateStr(d) {
    return d instanceof Date ? d.toISOString().slice(0, 10) : String(d).slice(0, 10);
  }

  function parseDate(str) {
    const parts = str.split('-');
    return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
  }

  function getWeekStart(dateStr) {
    const d = parseDate(dateStr);
    const day = d.getDay();
    d.setDate(d.getDate() - day);
    return toDateStr(d);
  }

  function getMonthKey(dateStr) {
    return dateStr.slice(0, 7);
  }

  function filterByRange(entries, startDate, endDate) {
    const start = startDate ? toDateStr(startDate) : '0000-00-00';
    const end = endDate ? toDateStr(endDate) : '9999-99-99';
    return entries.filter((e) => e.date >= start && e.date <= end);
  }

  function filterByProvider(entries, provider) {
    if (!provider || provider === 'all') return entries;
    return entries.filter((e) => e.provider === provider);
  }

  function aggregate(entries) {
    return entries.reduce((acc, e) => {
      acc.conversations += e.conversations || 0;
      acc.tokens += e.tokensEstimate || 0;
      acc.cost += e.costEstimate || 0;
      acc.entryCount += 1;
      return acc;
    }, { conversations: 0, tokens: 0, cost: 0, entryCount: 0 });
  }

  function dailyBreakdown(entries) {
    const map = {};
    entries.forEach((e) => {
      if (!map[e.date]) map[e.date] = [];
      map[e.date].push(e);
    });
    const days = Object.keys(map).sort();
    return days.map((day) => ({
      date: day,
      ...aggregate(map[day])
    }));
  }

  function weeklyBreakdown(entries) {
    const map = {};
    entries.forEach((e) => {
      const week = getWeekStart(e.date);
      if (!map[week]) map[week] = [];
      map[week].push(e);
    });
    const weeks = Object.keys(map).sort();
    return weeks.map((week) => ({
      weekStart: week,
      ...aggregate(map[week])
    }));
  }

  function monthlyBreakdown(entries) {
    const map = {};
    entries.forEach((e) => {
      const month = getMonthKey(e.date);
      if (!map[month]) map[month] = [];
      map[month].push(e);
    });
    const months = Object.keys(map).sort();
    return months.map((month) => ({
      month,
      ...aggregate(map[month])
    }));
  }

  function providerBreakdown(entries) {
    const map = {};
    entries.forEach((e) => {
      const p = e.provider || 'unknown';
      if (!map[p]) map[p] = [];
      map[p].push(e);
    });
    return Object.keys(map).map((provider) => ({
      provider,
      ...aggregate(map[provider])
    }));
  }

  function todayStats(entries) {
    const today = toDateStr(new Date());
    return aggregate(filterByRange(entries, today, today));
  }

  function thisWeekStats(entries) {
    const today = new Date();
    const start = new Date(today);
    start.setDate(today.getDate() - today.getDay());
    return aggregate(filterByRange(entries, start, today));
  }

  function thisMonthStats(entries) {
    const today = new Date();
    const start = new Date(today.getFullYear(), today.getMonth(), 1);
    return aggregate(filterByRange(entries, start, today));
  }

  function last30Days(entries) {
    const today = new Date();
    const start = new Date(today);
    start.setDate(today.getDate() - 30);
    return dailyBreakdown(filterByRange(entries, start, today));
  }

  return {
    filterByRange,
    filterByProvider,
    aggregate,
    dailyBreakdown,
    weeklyBreakdown,
    monthlyBreakdown,
    providerBreakdown,
    todayStats,
    thisWeekStats,
    thisMonthStats,
    last30Days,
    toDateStr
  };
})();
