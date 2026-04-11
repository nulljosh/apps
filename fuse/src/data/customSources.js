// Custom event sources injected alongside iCal

// BC Income Assistance pays last Wednesday of each month
function lastWednesdayOfMonth(year, month) {
  const lastDay = new Date(year, month + 1, 0)
  const dow = lastDay.getDay()
  const offset = (dow >= 3) ? dow - 3 : dow + 4
  return new Date(year, month, lastDay.getDate() - offset)
}

function nextPayday() {
  const now = new Date()
  let d = lastWednesdayOfMonth(now.getFullYear(), now.getMonth())
  if (d <= now) {
    d = lastWednesdayOfMonth(now.getFullYear(), now.getMonth() + 1)
  }
  d.setHours(9, 0, 0, 0)
  return d
}

export function getCustomEvents() {
  const payday = nextPayday()
  return [
    {
      id: 'tally-payday',
      title: 'Payday',
      date: payday,
      category: 'payday',
      source: 'tally',
      allDay: false,
    },
  ]
}

// Mock iCal events for web (real EventKit used on iOS/macOS)
export function getMockCalendarEvents() {
  const now = new Date()
  const d = (daysAhead, h = 10, m = 0) => {
    const dt = new Date(now)
    dt.setDate(dt.getDate() + daysAhead)
    dt.setHours(h, m, 0, 0)
    return dt
  }

  return [
    { id: 'mock-1', title: 'Doctor appointment', date: d(0, 14, 30), category: 'ical', source: 'Calendar', allDay: false },
    { id: 'mock-2', title: 'Pre-Calc 12 test', date: d(2, 9, 0),  category: 'ical', source: 'School', allDay: false },
    { id: 'mock-3', title: 'UVic application deadline', date: d(21, 23, 59), category: 'ical', source: 'School', allDay: true },
    { id: 'mock-4', title: 'A&P 12 exam', date: d(5, 10, 0),  category: 'ical', source: 'School', allDay: false },
    { id: 'mock-5', title: 'Ben visiting', date: d(8, 12, 0),  category: 'ical', source: 'Personal', allDay: false },
    { id: 'mock-6', title: 'PWD follow-up', date: d(14, 11, 0), category: 'ical', source: 'Personal', allDay: false },
  ]
}
