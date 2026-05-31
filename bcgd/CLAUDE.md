# BC Garage Doors (BCGD)
v4.0.0

Monorepo for BC Garage Doors -- customer-facing website, internal operations dashboard, and native companion apps. One shared Supabase backend (Postgres + Auth + RLS + Realtime) is the source of truth. Multi-tenant from day one (`org_id` + RLS everywhere); Best Choice Garage Doors is org #1.

## Structure
- `web/` -- Static HTML landing page. Conversion-focused, emergency-first. Booking form inserts into the Supabase `leads` table (anon). Live: bcgd.heyitsmejosh.com
- `dashboard/` -- Vite + React 19 + Supabase ops dashboard. Inventory, jobs, customers, leads inbox, email/password auth, realtime. Live: bcgd-dashboard.heyitsmejosh.com
- `ios/` -- SwiftUI iPhone app, full CRUD. Currently SwiftData/local; Supabase sync is the next pass.
- `macos/` -- SwiftUI macOS app, full CRUD. Currently SwiftData/local; Supabase sync is the next pass.
- `supabase/migrations/` -- SQL schema + RLS policies + signup trigger + org #1 seed.

## Stack
- **web/**: Static HTML, no build step; Supabase via CDN for the booking form
- **dashboard/**: Vite + React 19, `@supabase/supabase-js`, Animate.css, Apple Liquid Glass design

## Entities
parts, customers, jobs, leads — each with `org_id`. RLS: `org_id = current_org_id()` (the caller's org from `profiles`). leads also allow anonymous insert into org #1 (the booking form).

## Features
- Inventory management (categories, +/- qty controls), search/filter/sort
- Low-stock alerts with reorder email (mailto), supplier-grouped reorder queue
- Browser notifications on stock threshold crossing
- Supabase email/password auth gate (replaces the old PIN gate; PIN remains an optional local lock)
- Jobs pipeline (Scheduled -> In Progress -> Done / Cancelled) with create/edit/advance + markdown import
- Leads inbox: website booking requests, convert-to-job or dismiss
- Customers list (deduped from jobs)
- Local activity history; CSV export
- Settings (alert email, alerts toggle)

## Supabase setup
See `README.md` "Supabase setup" — create project, run `supabase/migrations/20260601000000_init.sql`, set `VITE_SUPABASE_URL`/`VITE_SUPABASE_ANON_KEY`, register the operator account, fill the landing-page constants. Requires a Mac (CLI + deploy).

## Deploy
```bash
# Landing page (fill SB_URL / SB_ANON_KEY / BCGD_ORG_UUID first)
cd web && npx vercel --prod

# Dashboard (vercel env must have VITE_SUPABASE_URL + VITE_SUPABASE_ANON_KEY)
cd dashboard && npm run build && npx vercel --prod
```

## Dev
```bash
cd dashboard && cp .env.example .env   # then add your Supabase keys
npm install && npm run dev             # Vite on :5180
```

## Rules
- No emojis
- No gradients or drop shadows
- Spring physics on interactive elements: cubic-bezier(0.34, 1.56, 0.64, 1)
- Mobile-first, Apple Liquid Glass design system
- No fake/seed data — ship empty states; real data entered via the dashboard

## Roadmap

### Next pass (Mac required)
iOS + macOS Supabase sync: add `supabase-swift` SPM to both `project.yml`s, replace the SwiftData `@Query` load with a Supabase data source (keep `Part`/`Job` Codable shapes), add email/password auth, build both targets green. The native apps already have full CRUD UI — this swaps the data layer.

### Future
- First-class customer records linked to jobs (`customer_id`); lead → customer conversion
- Job calendar + technician scheduling; digital inspection checklists; tune-up reminders (SMS/email)
- Quick-quote calculator; missed-call recovery autopilot
- Landing slim-down (~2100 → ~1000 lines), photo/before-after gallery
- B2B: open public signup → org self-provisioning (schema already supports it)
