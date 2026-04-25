import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import './Settings.css'

export default function Settings() {
  const { user, updateProfile, logout } = useAuth()
  const navigate = useNavigate()
  const [name, setName] = useState(user?.name || '')
  const [email, setEmail] = useState(user?.email || '')
  const [saved, setSaved] = useState(false)

  const prefs = user?.preferences || {}
  const [notifications, setNotifications] = useState(prefs.notifications ?? true)
  const [priceMin, setPriceMin] = useState(prefs.priceMin ?? 0)
  const [priceMax, setPriceMax] = useState(prefs.priceMax ?? 5000000)
  const [location, setLocation] = useState(prefs.location ?? 'all')
  const [propertyType, setPropertyType] = useState(prefs.propertyType ?? 'all')

  function handleSave(e) {
    e.preventDefault()
    updateProfile({
      name: name.trim(),
      email: email.trim(),
      preferences: { notifications, priceMin, priceMax, location, propertyType }
    })
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  function handleLogout() {
    logout()
    navigate('/login')
  }

  return (
    <div className="page">
      <div className="settings-container fade-up">
        <h1>Settings</h1>
        <p className="subtitle" style={{ color: 'var(--muted)', marginBottom: '2rem' }}>
          Manage your profile and preferences
        </p>

        <form onSubmit={handleSave}>
          <div className="settings-section">
            <h3 className="section-label">Profile</h3>
            <div className="settings-avatar">
              <div className="avatar-circle">
                {name.charAt(0).toUpperCase()}
              </div>
            </div>
            <div className="settings-fields">
              <div className="input-group">
                <label htmlFor="name">Name</label>
                <input
                  id="name"
                  type="text"
                  value={name}
                  onChange={e => setName(e.target.value)}
                />
              </div>
              <div className="input-group">
                <label htmlFor="email">Email</label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                />
              </div>
            </div>
          </div>

          <div className="settings-section">
            <h3 className="section-label">Notifications</h3>
            <div className="settings-toggle-row">
              <span>New listing alerts</span>
              <button
                type="button"
                className={`toggle ${notifications ? 'active' : ''}`}
                onClick={() => setNotifications(!notifications)}
              />
            </div>
          </div>

          <div className="settings-section">
            <h3 className="section-label">Search Preferences</h3>
            <div className="settings-fields">
              <div className="settings-fields-row">
                <div className="input-group">
                  <label htmlFor="priceMin">Min Price</label>
                  <select id="priceMin" value={priceMin} onChange={e => setPriceMin(Number(e.target.value))}>
                    <option value={0}>No min</option>
                    <option value={200000}>$200K</option>
                    <option value={500000}>$500K</option>
                    <option value={750000}>$750K</option>
                    <option value={1000000}>$1M</option>
                    <option value={1500000}>$1.5M</option>
                    <option value={2000000}>$2M</option>
                  </select>
                </div>
                <div className="input-group">
                  <label htmlFor="priceMax">Max Price</label>
                  <select id="priceMax" value={priceMax} onChange={e => setPriceMax(Number(e.target.value))}>
                    <option value={500000}>$500K</option>
                    <option value={750000}>$750K</option>
                    <option value={1000000}>$1M</option>
                    <option value={1500000}>$1.5M</option>
                    <option value={2000000}>$2M</option>
                    <option value={3000000}>$3M</option>
                    <option value={5000000}>$5M+</option>
                  </select>
                </div>
              </div>
              <div className="input-group">
                <label htmlFor="location">Preferred Location</label>
                <select id="location" value={location} onChange={e => setLocation(e.target.value)}>
                  <option value="all">All BC</option>
                  <option value="vancouver">Vancouver</option>
                  <option value="burnaby">Burnaby</option>
                  <option value="richmond">Richmond</option>
                  <option value="northVan">North Vancouver</option>
                  <option value="victoria">Victoria</option>
                  <option value="kelowna">Kelowna</option>
                </select>
              </div>
              <div className="input-group">
                <label htmlFor="propertyType">Property Type</label>
                <select id="propertyType" value={propertyType} onChange={e => setPropertyType(e.target.value)}>
                  <option value="all">All types</option>
                  <option value="house">House</option>
                  <option value="condo">Condo</option>
                  <option value="townhouse">Townhouse</option>
                </select>
              </div>
            </div>
          </div>

          <div className="settings-actions">
            <button type="submit" className="btn btn-primary">
              {saved ? 'Saved' : 'Save changes'}
            </button>
            <button type="button" className="btn btn-danger" onClick={handleLogout}>
              Sign out
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
