## [v4.0.0] — 2026-05-31

- Real Supabase backend (Postgres + Auth + RLS + Realtime) as the single source of truth
- Multi-tenant schema: orgs, profiles, parts, customers, jobs, leads — `org_id` + RLS on every table
- Dashboard: email/password auth gate replaces the PIN gate; live parts/jobs/leads with realtime sync
- Leads inbox: website booking requests land in the dashboard; convert-to-job or dismiss
- Landing booking form writes to the `leads` table (anonymous insert, pinned to org #1)
- No fake/seed data — empty states; real data entered in-app
- Jobs pipeline statuses: Scheduled → In Progress → Done / Cancelled (Lead is now a separate entity)
- Migration: `supabase/migrations/20260601000000_init.sql` (schema + RLS + signup trigger + org seed)
- iOS/macOS Supabase sync deferred to the next (Mac) pass — native apps stay full-CRUD SwiftData for now

## [v0.0.1] — 2026-05-22

- 4c5c37a chore: snow leopard pass
- 526942e auto: daily sync 2026-05-14
- 66ecb90 feat: dashboard foundation + landing refresh
- 8adca7d auto: daily sync 2026-04-30
- 1c2927c auto: daily sync 2026-04-29
- 4fc2202 docs: add website clone task to roadmap
- a7ade5c auto: daily sync 2026-04-25

# Changelog

## [v0.0.1] — 2026-05-16

- 526942e auto: daily sync 2026-05-14
- 66ecb90 feat: dashboard foundation + landing refresh
- 8adca7d auto: daily sync 2026-04-30
- 1c2927c auto: daily sync 2026-04-29
- 4fc2202 docs: add website clone task to roadmap
- a7ade5c auto: daily sync 2026-04-25
