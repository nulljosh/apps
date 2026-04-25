import { createContext, useContext, useState, useEffect, useMemo } from 'react'

const FavoritesContext = createContext(null)

export function FavoritesProvider({ children }) {
  const [favorites, setFavorites] = useState(() => {
    const stored = localStorage.getItem('roost_favorites')
    return stored ? JSON.parse(stored) : []
  })

  const favoriteSet = useMemo(() => new Set(favorites), [favorites])

  useEffect(() => {
    localStorage.setItem('roost_favorites', JSON.stringify(favorites))
  }, [favorites])

  function toggle(listingId) {
    setFavorites(prev =>
      favoriteSet.has(listingId)
        ? prev.filter(id => id !== listingId)
        : [...prev, listingId]
    )
  }

  function isFavorite(listingId) {
    return favoriteSet.has(listingId)
  }

  return (
    <FavoritesContext.Provider value={{ favorites, favoriteSet, toggle, isFavorite }}>
      {children}
    </FavoritesContext.Provider>
  )
}

export function useFavorites() {
  return useContext(FavoritesContext)
}
