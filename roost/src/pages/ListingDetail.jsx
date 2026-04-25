import { useParams, useNavigate, Link } from 'react-router-dom'
import { useState } from 'react'
import { getListingById, formatPriceFull } from '../data/listings'
import { useFavorites } from '../context/FavoritesContext'
import './ListingDetail.css'

export default function ListingDetail() {
  const { id } = useParams()
  const navigate = useNavigate()
  const listing = getListingById(id)
  const { toggle, isFavorite } = useFavorites()
  const [photoIdx, setPhotoIdx] = useState(0)

  if (!listing) {
    return (
      <div className="page" style={{ textAlign: 'center', paddingTop: '120px' }}>
        <h2>Listing not found</h2>
        <Link to="/" className="btn btn-primary" style={{ marginTop: '1rem' }}>Back to listings</Link>
      </div>
    )
  }

  const fav = isFavorite(listing.id)

  return (
    <div className="page">
      <div className="detail-layout fade-up">
        <div className="detail-gallery">
          <div className="detail-main-photo">
            <img src={listing.photos[photoIdx]} alt={listing.address} />
            <button className="detail-back" onClick={() => navigate(-1)}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <path d="M19 12H5M12 19l-7-7 7-7"/>
              </svg>
            </button>
            <button
              className={`fav-btn ${fav ? 'active' : ''}`}
              onClick={() => toggle(listing.id)}
              style={{ position: 'absolute', top: '1rem', right: '1rem' }}
            >
              <svg width="18" height="18" viewBox="0 0 24 24" fill={fav ? 'currentColor' : 'none'} stroke="currentColor" strokeWidth="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
            </button>
          </div>
          <div className="detail-thumbs">
            {listing.photos.map((photo, i) => (
              <button
                key={i}
                className={`detail-thumb ${i === photoIdx ? 'active' : ''}`}
                onClick={() => setPhotoIdx(i)}
              >
                <img src={photo} alt="" />
              </button>
            ))}
          </div>
        </div>

        <div className="detail-info">
          <div className="detail-price">{formatPriceFull(listing.price)}</div>
          <div className="detail-address">{listing.address}</div>
          <div className="detail-neighborhood">{listing.neighborhood}, {listing.city}</div>

          <div className="detail-stats">
            <div className="detail-stat">
              <span className="detail-stat-value">{listing.beds}</span>
              <span className="detail-stat-label">Beds</span>
            </div>
            <div className="detail-stat">
              <span className="detail-stat-value">{listing.baths}</span>
              <span className="detail-stat-label">Baths</span>
            </div>
            <div className="detail-stat">
              <span className="detail-stat-value">{listing.sqft.toLocaleString()}</span>
              <span className="detail-stat-label">Sq Ft</span>
            </div>
            <div className="detail-stat">
              <span className="detail-stat-value">{listing.year}</span>
              <span className="detail-stat-label">Built</span>
            </div>
          </div>

          <div className="detail-section">
            <h3 className="section-label">About</h3>
            <p className="detail-description">{listing.description}</p>
          </div>

          <div className="detail-section">
            <h3 className="section-label">Features</h3>
            <ul className="detail-features">
              {listing.features.map(f => (
                <li key={f}>{f}</li>
              ))}
            </ul>
          </div>

          <div className="detail-section">
            <h3 className="section-label">Details</h3>
            <div className="detail-meta-grid">
              <div><span className="detail-meta-label">Type</span><span className="detail-meta-value">{listing.type}</span></div>
              <div><span className="detail-meta-label">MLS #</span><span className="detail-meta-value">{listing.mlsNumber}</span></div>
              <div><span className="detail-meta-label">Listed</span><span className="detail-meta-value">{listing.listedDaysAgo} day{listing.listedDaysAgo !== 1 ? 's' : ''} ago</span></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
