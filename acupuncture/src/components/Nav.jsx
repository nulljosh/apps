import { Link, useLocation } from 'react-router-dom'
import './Nav.css'

const tabs = [
  { path: '/', label: 'Home', icon: 'M3 12l9-9 9 9M5 10v10a1 1 0 001 1h3a1 1 0 001-1v-4h4v4a1 1 0 001 1h3a1 1 0 001-1V10' },
  { path: '/feet', label: 'Feet', icon: 'M12 21c-3 0-5-2-6-5s-1-7 1-9 5-3 5-3 3 1 5 3 2 6 1 9-3 5-6 5z' },
  { path: '/hands', label: 'Hands', icon: 'M18 11V6a2 2 0 00-4 0v2M14 8V4a2 2 0 00-4 0v6M10 6V3a2 2 0 00-4 0v9M7 15l-2 4h14l-2-4' },
  { path: '/acupuncture', label: 'Points', icon: 'M12 2v6m0 4v10M9 6l3-4 3 4M9 18l3 4 3-4' },
  { path: '/symptoms', label: 'Symptoms', icon: 'M9 12h6m-3-3v6m8-3a9 9 0 11-18 0 9 9 0 0118 0z' }
]

export default function Nav() {
  const { pathname } = useLocation()

  return (
    <nav className="bottom-nav">
      {tabs.map(t => (
        <Link key={t.path} to={t.path} className={`nav-tab ${pathname === t.path ? 'active' : ''}`}>
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d={t.icon} />
          </svg>
          <span>{t.label}</span>
        </Link>
      ))}
    </nav>
  )
}
