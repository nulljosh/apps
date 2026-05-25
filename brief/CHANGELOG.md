# Changelog — Brief

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
