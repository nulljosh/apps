import { createContext, useContext, useState } from 'react'

const FiltersContext = createContext(null)

const defaultFilters = {
  priceMin: 0,
  priceMax: 10000000,
  beds: 0,
  propertyType: 'all',
  sort: 'price-asc',
  favoritesOnly: false
}

export function FiltersProvider({ children }) {
  const [filters, setFilters] = useState(defaultFilters)

  function updateFilter(key, value) {
    setFilters(prev => ({ ...prev, [key]: value }))
  }

  function resetFilters() {
    setFilters(defaultFilters)
  }

  return (
    <FiltersContext.Provider value={{ filters, updateFilter, resetFilters }}>
      {children}
    </FiltersContext.Provider>
  )
}

export function useFilters() {
  return useContext(FiltersContext)
}
