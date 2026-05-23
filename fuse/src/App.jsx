import { BrowserRouter, Routes, Route, NavLink } from 'react-router-dom'
import Timeline from './pages/Timeline.jsx'
import Upcoming from './pages/Upcoming.jsx'

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
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="4" width="18" height="18" rx="3"/>
      <line x1="16" y1="2" x2="16" y2="6"/>
      <line x1="8" y1="2" x2="8" y2="6"/>
      <line x1="3" y1="10" x2="21" y2="10"/>
    </svg>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Timeline />} />
        <Route path="/upcoming" element={<Upcoming />} />
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
      </nav>
    </BrowserRouter>
  )
}
