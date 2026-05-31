# Best Choice Garage Doors — Dashboard
v4.0.0

Operations dashboard for Best Choice Garage Doors (bcgaragedoors.ca). Inventory, jobs pipeline, customers, leads inbox. Supabase backend (Postgres + Auth + RLS + Realtime), email/password auth.

## Stack
- Vite + React 19
- Supabase (`@supabase/supabase-js`) — parts, jobs, customers, leads + realtime
- localStorage only for the activity log, settings, and the optional PIN lock
- Animate.css for entrance animations
- Apple Liquid Glass design system
- Mobile-first PWA

## Structure
- `src/main.jsx` -- Vite entry point; wraps App in AuthProvider
- `src/App.jsx` -- Main app, Supabase data load + realtime, inventory intelligence, auth gate
- `src/App.css` -- All styles, CSS variables, responsive
- `src/lib/supabase.js` -- Supabase client (reads VITE_SUPABASE_URL / VITE_SUPABASE_ANON_KEY; demo-mode fallback)
- `src/lib/db.js` -- parts/jobs/leads CRUD + realtime subscribe; snake_case ↔ app-shape mappers
- `src/lib/storage.js` -- local history/settings/PIN, CATEGORIES, JOB_STATUSES, generateId, parseJobsMarkdown
- `src/context/AuthContext.jsx` -- session + caller's org_id
- `src/components/Login.jsx` -- email/password sign in / register (gates the app)
- `src/components/Logo.jsx` -- SVG garage door logo
- `src/components/PinGate.jsx` -- 4-digit PIN keypad modal (optional secondary local lock)
- `src/components/PartList.jsx` -- Sortable inventory table with qty controls
- `src/components/PartForm.jsx` -- Add/edit part form
- `src/components/JobList.jsx` -- Job pipeline with status color pills
- `src/components/JobForm.jsx` -- Add/edit job form
- `src/components/LeadList.jsx` -- Booking-request inbox (convert to job / dismiss)
- `src/components/HistoryLog.jsx` -- Timestamped activity feed (local)
- `src/components/Settings.jsx` -- Email, PIN, alerts settings
- `src/components/CustomerList.jsx` -- Deduplicated customer list from jobs

## Features
- Dashboard: total SKUs, units, inventory value, low stock count, open leads, scheduled jobs
- Inventory Intelligence: category bar chart (CSS), value-at-risk summary, supplier reorder queue
- Add/edit/delete parts (name, SKU, category, quantity, min threshold, cost, supplier)
- Inline quantity +/- controls with history logging
- Low stock alerts (OUT badge, LOW badge, severity-tiered)
- Jobs pipeline: Scheduled → In Progress → Done / Cancelled (+ markdown import)
- Leads inbox: website booking requests, convert-to-job or dismiss
- Customer list deduped from jobs
- Search by name, SKU, supplier; filter by category; sort all columns
- Activity history with relative timestamps (local)
- CSV export, reorder mailto links per supplier
- Supabase email/password auth gate; realtime sync across tabs/devices
- Settings: alert email, alert toggle, optional PIN lock

## Run
```bash
cp .env.example .env          # add VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY
npm install && npm run dev    # Vite dev server on :5180
npm run build                 # Production build
```

Without keys the app runs in "not configured" mode and shows a setup notice on the login screen.

## Deploy
```bash
# vercel env must have VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY
npm run build && npx vercel --prod
```

## Rules
- No emojis
- No gradients or drop shadows
- Spring physics: cubic-bezier(0.34, 1.56, 0.64, 1)
- No fake/seed data — empty states; real data entered in-app
- Business data in Supabase (org-scoped via RLS); only history/settings/PIN are local
