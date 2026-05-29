# Changelog — Brief

## [v6.3.0] — 2026-05-29

### CASE-0001 reconciliation + limitation overlay
- Merged the drifted web and Swift datasets into one consistent Case 01 across web + iOS +
  macOS. Web's section-based grounds (s.8/s.9/s.7/s.10(b)/s.12/battery/false imprisonment/
  negligent investigation) are now canonical and ported into `CaseData.swift`, replacing the
  old harm-based set. Dollar conflicts resolved to the higher figure (scenarios top at
  $2.5–4M; web `CEILING_PROJECTION` 2250 → 4000).
- Officers: removed all name strings (`Cst. Darcy G. Ng`, "both Daryls"). Identities unknown,
  pending ATIP, on every platform.
- Fixed s.18 → s.19 (adult disability, not minority) in grounds, banner, call script, tags.
- Rewrote the fabricated 2025-08-02 "first therapy session" journal entry to the truth:
  ongoing therapy with regular counsellor writing the PTSD/s.19 letter; one-off EMDR consult
  was not a fit. No invented date.
- Added Law Society paid limitation read (1-800-663-1919) as the lead action; pivoted the
  "Now" timeline step away from cold-pitching contingency firms. Marked Klein declined.
- Cache bumped `?v=16`/`brief-v16` → `?v=17`/`brief-v17`.

## [v6.2.0] — 2026-05-28

### Deploy fix
- Live `heyitsmejosh.com/brief` was serving a stale single-case build while `apps/brief/web` held
  the current multi-case v6.1.x. Synced the canonical web source to the live deploy folder and
  bumped cache to `?v=16` / `brief-v16`. Fixed `sw.js` precache paths (were `/`-rooted, now `/brief/`,
  so `addAll` no longer 404-rejects).
- Corrected `apps/brief/CLAUDE.md`: web is NOT auto-deployed — documented the real copy + cache-bump
  + push procedure (the doc error that caused the regression).

### CASE-0001
- Added **Dinsley Litigation** (Sean Dinsley, Maple Ridge — civil litigation + personal injury,
  604-477-0766 / admin@dinsleylawcorp.ca) to the lawyer list + outreach checklist, all platforms.
- Added explicit "Call CBA BC Lawyer Referral Service (604-687-3221)" checklist task.

### Web
- `?pin=7743` overlay bypass and `?case=rcmp|family` deep-link wired into `script.js`.
- Hardened Supabase init: try/catch + null-client guards so a CDN failure degrades to a read-only
  render instead of a blank page. Escaped two apostrophes that broke `script.js` parsing (`didn't`,
  `wouldn't` in single-quoted strings).

## [v6.1.0] — 2026-05-25

### CASE-0001 (Trommel v. AG Canada)
- Arvay Finlay marked declined — Robin Gage (Managing Partner), "no capacity", May 25
- Thomas Harding and Neil Chantler promoted to top of lawyer list with PRIORITY visual callout (blue left-border on card)
- Checklist now sorts by leverage value descending, undone items first — TH/NC surface at top
- Timeline "Now" step updated: names TH/NC directly with phone numbers, notes all declined firms
- Checklist items 17/18 added for TH/NC with contact details
- Paul Kent item marked done (declined May 18)
- CSS: added `.tag.urgent` (blue), `.tag.fail` (red), `.tag.status.declined` (red), `.lawyer.priority` (blue left-border)

### Web
- Cache-bust bumped to v=8

---

## [v6.0.0] — 2026-05-24

- CASE-0002 (Trommel v. Trommel) added — family tort with separate grounds, damages, checklist
- Cover header + stamp circle design refresh
- Risk field added to all grounds — AG argument + rebuttal per ground
- Canonical CaseData.json — macOS symlinks iOS CaseData.swift

## [v5.0.0] — 2026-05-22

- Two-case architecture (CASE-0001 + CASE-0002) — iOS + macOS case picker
- Face ID biometric lock
- Password auth replacing magic link (two-step flow)
- Supabase DB sync: checklist, lawyer status, journal entries cross-platform

## [v4.0.0] — 2026-05-17

- macOS native app added (SwiftUI, macOS 14+)
- CRCC complaint item + email-first outreach strategy
- macos symlinks ios CaseData.swift — single source of truth

## [v3.0.0] — 2026-05-15

- Full DOM render (no innerHTML), Supabase auth + DB sync
- Journal tab: add/edit/delete entries, synced to DB
- Lawyer status cycling, auto system theme

## [v2.0.0] — 2026-05-13

- iOS native app (SwiftUI, iOS 17+) — SectionCard, grounds accordion, witnesses, call script
- Supabase auth on iOS/macOS

## [v1.0.0] — 2026-05-11

- Initial release — web PWA, 8 Charter grounds, damages stack, Ward framework, checklist
