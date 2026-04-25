# roost
v2.0.0

## Rules

- Mobile-first layout, horizontal filter chips on small screens
- Dark Editorial design (BC gov blue variant): navy `#0c1220`, blue `#1a5a96`/`#2472b2`/`#4e9cd7`, Fraunces + DM Sans
- Map markers stay as price pill SVGs
- No emojis

## Run

```bash
npm install && npm run dev
npm run build
```

## Key Files

- src/main.jsx: App bootstrap and Vite entry
- src/App.jsx: Routing and protected routes
- src/context/AuthContext.jsx: localStorage auth (login, register, profile)
- src/context/FavoritesContext.jsx: Favorites with localStorage sync
- src/context/FiltersContext.jsx: Price, beds, type, sort filters
- src/components/MapView.jsx: Leaflet map with price pill markers
- src/components/FilterBar.jsx: Horizontal chip filter bar
- src/components/ListingCard.jsx: Listing card with photo and stats
- src/data/listings.js: 50 mock BC listings with seeded generation
- src/pages/: Login, Register, ForgotPassword, Listings, ListingDetail, Settings
