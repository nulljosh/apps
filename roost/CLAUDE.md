# roost
v1.1.0

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

- src/main.jsx: App bootstrap and Vite entry.
- src/App.jsx: Core layout and page routing.
- src/hooks/useListings.js: Listing data access and derived state.
- src/hooks/useFilters.js: Filtering and sorting logic.
- src/context/FavoritesContext.jsx: Favorites state with localStorage sync.
- src/components/MapMarker.jsx: Zillow-style price pill SVG markers.
- src/components/ImageCarousel.jsx: Listing photo carousel and lightbox.
- src/data/mock-listings.js: 50 mock BC listings with enriched data.
