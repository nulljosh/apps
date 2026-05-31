<img src="icon.svg" width="80">

# BC Garage Doors

![version](https://img.shields.io/badge/version-v4.0.0-blue)

Customer-facing website and operations platform for Best Choice Garage Doors (bcgaragedoors.ca).
One shared **Supabase** backend (Postgres + Auth + RLS + Realtime) is the single source of truth for
every surface. Multi-tenant from day one (`org_id` + RLS on every table) — Best Choice Garage Doors is
org #1.

## Projects

| Directory | Description | URL |
|-----------|-------------|-----|
| `web/` | Conversion landing page; booking form writes to the leads inbox | [bcgd.heyitsmejosh.com](https://bcgd.heyitsmejosh.com) |
| `dashboard/` | Ops dashboard — inventory, jobs, customers, leads (Vite + React 19 + Supabase) | [bcgd-dashboard.heyitsmejosh.com](https://bcgd-dashboard.heyitsmejosh.com) |
| `ios/` | SwiftUI iPhone app (full CRUD, currently SwiftData/local — Supabase sync is the next pass) | — |
| `macos/` | SwiftUI macOS app (full CRUD, currently SwiftData/local — Supabase sync is the next pass) | — |

## Entities

Inventory (parts), Customers, Jobs, Leads. Every table carries `org_id`; RLS scopes all rows to the
caller's org via their `profiles` row. The public booking form may insert leads anonymously, but only
into org #1.

## Supabase setup (run once, from a Mac)

1. **Create a project** at [supabase.com](https://supabase.com).
2. **Run the migration**: Supabase Dashboard → SQL Editor → paste
   `supabase/migrations/20260601000000_init.sql` and run (or `supabase db push`). This creates the
   schema, RLS policies, the signup trigger, and seeds org #1.
3. **Dashboard env**: in `dashboard/`, `cp .env.example .env` and set `VITE_SUPABASE_URL` +
   `VITE_SUPABASE_ANON_KEY` (Supabase → Project Settings → API). For prod, also `vercel env add` both.
4. **Create the operator account**: `npm run dev`, open the dashboard, **Register** dad's email/password.
   The trigger auto-creates his profile in org #1. (Confirm the email if confirmations are on.)
5. **Landing form**: in `web/index.html`, fill `SB_URL`, `SB_ANON_KEY`, and `BCGD_ORG_UUID` (the seeded
   org id) near the bottom `<script>` block.
6. **Real data**: no seed parts/customers ship. Add dad's actual parts via the dashboard (or import
   jobs through the Jobs → Import box).
7. **Deploy**: `cd dashboard && npm run build && npx vercel --prod`; redeploy `web/` with `npx vercel --prod`.

## Verify

- **RLS**: with a second test org/user, confirm cross-org reads return nothing, and that an anonymous
  client can insert a lead but not read another org's rows.
- **Web**: log in, add/edit/delete a part → reload → persists; open a second tab → realtime reflects the
  change; submit the landing booking form → the lead appears in the dashboard's Booking Requests inbox.

## Roadmap

### Next pass (Mac required)
- **iOS / macOS Supabase sync**: add `supabase-swift` SPM to both `project.yml`s, replace the SwiftData
  `@Query` load with a Supabase data source (keep the `Part`/`Job` Codable shapes), add the same
  email/password auth, build both targets green.

### Dashboard
- First-class customer records linked to jobs via `customer_id`; lead → customer conversion.
- Job calendar view, assign technicians to time slots.
- Digital inspection checklists; automated annual tune-up reminders (SMS/email).

### Web
- Photo gallery / before-after section.
- Slim the landing page (~2100 → ~1000 lines).

### B2B
- Open public signup → org self-provisioning (schema already supports it).

## License

MIT 2026, Joshua Trommel
