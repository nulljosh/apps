import { Link, useLocation } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import './Nav.css'

export default function Nav() {
  const { user } = useAuth()
  const location = useLocation()

  return (
    <nav className="nav">
      <div className="nav-inner">
        <Link to="/" className="nav-logo">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M3 21V9l9-7 9 7v12H15v-6h-2v6H3z" fill="currentColor" opacity="0.9"/>
            <path d="M10 21v-4h4v4" stroke="var(--blue-light)" strokeWidth="1.5" fill="none"/>
          </svg>
          <span>Roost</span>
        </Link>
        <div className="nav-links">
          <Link
            to="/"
            className={`nav-link ${location.pathname === '/' ? 'active' : ''}`}
          >
            Listings
          </Link>
          <Link
            to="/settings"
            className={`nav-link ${location.pathname === '/settings' ? 'active' : ''}`}
          >
            {user?.name?.split(' ')[0] || 'Settings'}
          </Link>
        </div>
      </div>
    </nav>
  )
}
