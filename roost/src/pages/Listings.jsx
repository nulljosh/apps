import { useMemo } from 'react'
import { listings } from '../data/listings'
import { useFilters } from '../context/FiltersContext'
import { useFavorites } from '../context/FavoritesContext'
import FilterBar from '../components/FilterBar'
import MapView from '../components/MapView'
import ListingCard from '../components/ListingCard'
import './Listings.css'

export default function Listings() {
  const { filters } = useFilters()
  const { favorites } = useFavorites()

  const filtered = useMemo(() => {
    let result = listings.filter(l => {
      if (l.price < filters.priceMin || l.price > filters.priceMax) return false
      if (filters.beds > 0 && l.beds < filters.beds) return false
      if (filters.propertyType !== 'all' && l.type !== filters.propertyType) return false
      if (filters.favoritesOnly && !favorites.includes(l.id)) return false
      return true
    })

    switch (filters.sort) {
      case 'price-asc':
        result.sort((a, b) => a.price - b.price)
        break
      case 'price-desc':
        result.sort((a, b) => b.price - a.price)
        break
      case 'newest':
        result.sort((a, b) => a.listedDaysAgo - b.listedDaysAgo)
        break
      case 'sqft-desc':
        result.sort((a, b) => b.sqft - a.sqft)
        break
    }

    return result
  }, [filters, favorites])

  return (
    <div className="page">
      <FilterBar resultCount={filtered.length} />
      <MapView listings={filtered} favorites={favorites} />
      <div className="listings-grid">
        {filtered.map((listing, i) => (
          <ListingCard key={listing.id} listing={listing} index={i} />
        ))}
        {filtered.length === 0 && (
          <div className="listings-empty fade-up">
            <h3>No listings found</h3>
            <p>Try adjusting your filters</p>
          </div>
        )}
      </div>
    </div>
  )
}
