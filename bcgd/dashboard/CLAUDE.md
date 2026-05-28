# Best Choice Garage Doors — Dashboard
v1.3.0

Operations dashboard for Best Choice Garage Doors (bcgaragedoors.ca). Inventory, jobs pipeline, PIN auth, activity log.

## Stack
- Vite + React 19
- localStorage persistence
- Animate.css for entrance animations
- Apple Liquid Glass design system
- Mobile-first PWA

## Structure
- `src/main.jsx` -- Vite entry point
- `src/App.jsx` -- Main app, state management, inventory intelligence
- `src/App.css` -- All styles, CSS variables, responsive
- `src/lib/storage.js` -- localStorage CRUD, history, CATEGORIES, JOB_STATUSES, generateId
- `src/components/Logo.jsx` -- SVG garage door logo
- `src/components/PinGate.jsx` -- 4-digit PIN keypad modal
- `src/components/PartList.jsx` -- Sortable inventory table with qty controls
- `src/components/PartForm.jsx` -- Add/edit part form
- `src/components/JobList.jsx` -- Job pipeline with status color pills
- `src/components/JobForm.jsx` -- Add/edit job form
- `src/components/HistoryLog.jsx` -- Timestamped activity feed
- `src/components/Settings.jsx` -- Email, PIN, alerts settings
- `src/components/CustomerList.jsx` -- Deduplicated customer list from jobs

## Features
- Dashboard: total SKUs, units, inventory value, low stock count, open leads, scheduled jobs
- Inventory Intelligence: category bar chart (CSS), value-at-risk summary, supplier reorder queue
- Add/edit/delete parts (name, SKU, category, quantity, min threshold, cost, supplier)
- Inline quantity +/- controls with history logging
- Low stock alerts (OUT badge, LOW badge, severity-tiered)
- Jobs pipeline: Lead → Scheduled → In Progress → Done → Cancelled
- Customer list deduped from jobs
- Search by name, SKU, supplier; filter by category; sort all columns
- Full activity history with relative timestamps
- CSV export, reorder mailto links per supplier
- PIN auth gate (4-digit keypad)
- Settings: alert email, PIN lock, alert toggle

## Run
```bash
npm install && npm run dev    # Vite dev server on :5180
npm run build                 # Production build
```

## Deploy
```bash
npm run build && npx vercel --prod
```

## Rules
- No emojis
- No gradients or drop shadows
- Spring physics: cubic-bezier(0.34, 1.56, 0.64, 1)
- All data in localStorage
