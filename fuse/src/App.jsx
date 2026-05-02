import { BrowserRouter, Routes, Route, NavLink } from 'react-router-dom'
import Timeline from './pages/Timeline.jsx'
import Upcoming from './pages/Upcoming.jsx'
import Settings from './pages/Settings.jsx'

function NavIcon({ type }) {
  if (type === 'timeline') return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round">
      <line x1="3" y1="12" x2="21" y2="12"/>
      <circle cx="8" cy="12" r="2" fill="currentColor" stroke="none"/>
      <circle cx="14" cy="12" r="2" fill="currentColor" stroke="none"/>
      <line x1="8" y1="12" x2="8" y2="7"/>
      <line x1="14" y1="12" x2="14" y2="16"/>
    </svg>
  )
  if (type === 'upcoming') return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="4" width="18" height="18" rx="3"/>
      <line x1="16" y1="2" x2="16" y2="6"/>
      <line x1="8" y1="2" x2="8" y2="6"/>
      <line x1="3" y1="10" x2="21" y2="10"/>
    </svg>
  )
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="3"/>
      <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
    </svg>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Timeline />} />
        <Route path="/upcoming" element={<Upcoming />} />
        <Route path="/settings" element={<Settings />} />
      </Routes>
      <nav className="nav">
        <NavLink to="/" end className={({ isActive }) => `nav-btn${isActive ? ' active' : ''}`}>
          <NavIcon type="timeline" />
          timeline
        </NavLink>
        <NavLink to="/upcoming" className={({ isActive }) => `nav-btn${isActive ? ' active' : ''}`}>
          <NavIcon type="upcoming" />
          upcoming
        </NavLink>
        <NavLink to="/settings" className={({ isActive }) => `nav-btn${isActive ? ' active' : ''}`}>
          <NavIcon type="settings" />
          calendars
        </NavLink>
      </nav>
    </BrowserRouter>
  )
}
