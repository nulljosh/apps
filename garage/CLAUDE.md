# Garage Door Services
v1.0.0

Inventory and stock tracking app for a garage door services company.

## Stack
- Vite + React 19
- localStorage persistence
- Animate.css for entrance animations
- Apple Liquid Glass design system
- Mobile-first PWA

## Structure
- `src/main.jsx` -- Vite entry point
- `src/App.jsx` -- Main app, routing, state management
- `src/App.css` -- All styles, CSS variables, responsive
- `src/components/Dashboard.jsx` -- Stock overview, stats, low stock alerts, category breakdown
- `src/components/PartForm.jsx` -- Add/edit part form
- `src/components/PartList.jsx` -- Inventory table with inline qty controls
- `src/components/HistoryLog.jsx` -- Stock change history log
- `src/lib/storage.js` -- localStorage CRUD, history, categories, ID generation

## Features
- Dashboard with total SKUs, units, inventory value, low stock count
- Add/edit/remove parts (name, SKU, category, quantity, min threshold, cost, supplier)
- Inline quantity +/- controls with history logging
- Low stock alerts (quantity <= min threshold)
- Search by name, SKU, or supplier
- Filter by category (Springs, Openers, Panels, Hardware, Remotes, Weatherstripping)
- Full stock change history with timestamps

## Run
```bash
npm install && npm run dev    # Vite dev server on :5180
npm run build                 # Production build
```

## Rules
- No emojis
- No gradients or drop shadows
- Spring physics on interactive elements: cubic-bezier(0.34, 1.56, 0.64, 1)
- All data in localStorage (garage_parts, garage_history)
