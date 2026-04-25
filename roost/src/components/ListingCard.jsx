import { Link } from 'react-router-dom'
import { useFavorites } from '../context/FavoritesContext'
import { formatPriceFull } from '../data/listings'
import './ListingCard.css'

export default function ListingCard({ listing, index = 0 }) {
  const { toggle, isFavorite } = useFavorites()
  const fav = isFavorite(listing.id)

  return (
    <Link
      to={`/listing/${listing.id}`}
      className={`listing-card card fade-up`}
      style={{ animationDelay: `${(index % 12) * 0.04}s` }}
    >
      <div className="listing-card-img">
        <img src={listing.photo} alt={listing.address} loading="lazy" />
        <button
          className={`fav-btn ${fav ? 'active' : ''}`}
          onClick={e => { e.preventDefault(); toggle(listing.id) }}
          aria-label={fav ? 'Remove from favorites' : 'Add to favorites'}
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill={fav ? 'currentColor' : 'none'} stroke="currentColor" strokeWidth="2">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
        </button>
        <span className="listing-type-badge">{listing.type}</span>
        {listing.listedDaysAgo <= 3 && <span className="listing-new-badge">New</span>}
      </div>
      <div className="listing-card-body">
        <div className="listing-price">{formatPriceFull(listing.price)}</div>
        <div className="listing-meta">
          <span>{listing.beds} bd</span>
          <span className="meta-dot" />
          <span>{listing.baths} ba</span>
          <span className="meta-dot" />
          <span>{listing.sqft.toLocaleString()} sqft</span>
        </div>
        <div className="listing-address">{listing.address}</div>
        <div className="listing-neighborhood">{listing.neighborhood}</div>
      </div>
    </Link>
  )
}
