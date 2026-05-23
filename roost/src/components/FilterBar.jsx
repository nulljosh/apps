import { useFilters } from '../context/FiltersContext'
import './FilterBar.css'

const priceRanges = [
  { label: 'Any price', min: 0, max: 10000000 },
  { label: 'Under $500K', min: 0, max: 500000 },
  { label: '$500K-$1M', min: 500000, max: 1000000 },
  { label: '$1M-$2M', min: 1000000, max: 2000000 },
  { label: '$2M+', min: 2000000, max: 10000000 }
]

const bedOptions = [
  { label: 'Any beds', value: 0 },
  { label: '1+', value: 1 },
  { label: '2+', value: 2 },
  { label: '3+', value: 3 },
  { label: '4+', value: 4 }
]

const typeOptions = [
  { label: 'All types', value: 'all' },
  { label: 'House', value: 'house' },
  { label: 'Condo', value: 'condo' },
  { label: 'Townhouse', value: 'townhouse' }
]

const sortOptions = [
  { label: 'Price: Low', value: 'price-asc' },
  { label: 'Price: High', value: 'price-desc' },
  { label: 'Newest', value: 'newest' },
  { label: 'Largest', value: 'sqft-desc' }
]

export default function FilterBar({ resultCount }) {
  const { filters, updateFilter } = useFilters()

  return (
    <div className="filter-bar fade-up">
      <div className="filter-row">
        <div className="filter-group">
          <span className="section-label">Price</span>
          <div className="chip-row">
            {priceRanges.map(r => (
              <button
                key={r.label}
                className={`chip ${filters.priceMin === r.min && filters.priceMax === r.max ? 'active' : ''}`}
                onClick={() => { updateFilter('priceMin', r.min); updateFilter('priceMax', r.max) }}
              >
                {r.label}
              </button>
            ))}
          </div>
        </div>
        <div className="filter-group">
          <span className="section-label">Beds</span>
          <div className="chip-row">
            {bedOptions.map(b => (
              <button
                key={b.label}
                className={`chip ${filters.beds === b.value ? 'active' : ''}`}
                onClick={() => updateFilter('beds', b.value)}
              >
                {b.label}
              </button>
            ))}
          </div>
        </div>
        <div className="filter-group">
          <span className="section-label">Type</span>
          <div className="chip-row">
            {typeOptions.map(t => (
              <button
                key={t.label}
                className={`chip ${filters.propertyType === t.value ? 'active' : ''}`}
                onClick={() => updateFilter('propertyType', t.value)}
              >
                {t.label}
              </button>
            ))}
          </div>
        </div>
        <div className="filter-group">
          <span className="section-label">Sort</span>
          <div className="chip-row">
            {sortOptions.map(s => (
              <button
                key={s.label}
                className={`chip ${filters.sort === s.value ? 'active' : ''}`}
                onClick={() => updateFilter('sort', s.value)}
              >
                {s.label}
              </button>
            ))}
          </div>
        </div>
      </div>
      <div className="filter-result-count">
        <span className="section-label">{resultCount} listing{resultCount !== 1 ? 's' : ''}</span>
        <button
          className={`chip ${filters.favoritesOnly ? 'active' : ''}`}
          onClick={() => updateFilter('favoritesOnly', !filters.favoritesOnly)}
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill={filters.favoritesOnly ? 'currentColor' : 'none'} stroke="currentColor" strokeWidth="2">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
          Favorites
        </button>
      </div>
    </div>
  )
}
