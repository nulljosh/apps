import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet'
import { useNavigate } from 'react-router-dom'
import L from 'leaflet'
import { formatPrice, formatPriceFull } from '../data/listings'
import './MapView.css'

function createPriceIcon(price, isFav) {
  const label = formatPrice(price)
  const bg = isFav ? '#c44040' : '#1a5a96'
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${label.length * 9 + 20}" height="32">
    <rect width="100%" height="24" rx="12" fill="${bg}"/>
    <text x="50%" y="16" fill="#fff" font-family="DM Sans,sans-serif" font-size="11" font-weight="600" text-anchor="middle">${label}</text>
    <polygon points="${label.length * 4.5 + 6},24 ${label.length * 4.5 + 10},24 ${label.length * 4.5 + 8},30" fill="${bg}"/>
  </svg>`
  return L.divIcon({
    html: svg,
    className: 'price-marker',
    iconSize: [label.length * 9 + 20, 32],
    iconAnchor: [(label.length * 9 + 20) / 2, 30]
  })
}

function MapMarkers({ listings, favorites }) {
  const navigate = useNavigate()

  return listings.map(listing => (
    <Marker
      key={listing.id}
      position={[listing.lat, listing.lng]}
      icon={createPriceIcon(listing.price, favorites.includes(listing.id))}
      eventHandlers={{
        click: () => navigate(`/listing/${listing.id}`)
      }}
    >
      <Popup className="roost-popup">
        <div className="popup-content">
          <img src={listing.photo} alt="" />
          <div className="popup-info">
            <strong>{formatPriceFull(listing.price)}</strong>
            <span>{listing.beds}bd / {listing.baths}ba / {listing.sqft.toLocaleString()}sf</span>
            <span className="popup-address">{listing.address}</span>
          </div>
        </div>
      </Popup>
    </Marker>
  ))
}

export default function MapView({ listings, favorites }) {
  return (
    <div className="map-container">
      <MapContainer
        center={[49.2827, -123.1207]}
        zoom={12}
        scrollWheelZoom={true}
        style={{ width: '100%', height: '100%' }}
      >
        <TileLayer
          attribution='&copy; <a href="https://carto.com/">CARTO</a>'
          url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
        />
        <MapMarkers listings={listings} favorites={favorites} />
      </MapContainer>
    </div>
  )
}
