<img src="icon.svg" width="80">

# brief-ios

![v1.1.0](https://img.shields.io/badge/version-1.1.0-blue) ![iOS 17](https://img.shields.io/badge/iOS-17%2B-black) ![Swift 6](https://img.shields.io/badge/Swift-6-orange)

Native iOS litigation planning app for *Trommel v. AG Canada*. SwiftUI port of [heyitsmejosh.com/brief](https://heyitsmejosh.com/brief).

**Case:** Charter violations from warrantless wellness-call entry by Langley RCMP, August 1, 2023. 8 stacked grounds. $800k–$1.5M likely settlement range.

## Features

- **Case tab:** facts grid, witness statements with legal annotations, 8 Charter grounds accordion, pain journal with add/edit/delete (Supabase-synced)
- **Money tab:** outcome scenarios with animated probability bars, per-head damage stack, Ward framework, comparable awards
- **Actions tab:** 11 lawyer contacts with tap-to-cycle outreach status (synced), evidence checklist (synced), call script + outreach email, timeline, risk analysis, evidence gaps, drafts
- **Auth:** Supabase magic link OTP, persistent session, deep link via `brief://` URL scheme
- **Theme:** follows system dark/light automatically

## Build

```bash
cd apps/brief/ios
xcodegen generate
open Brief.xcodeproj
```

Run on iPhone simulator (iOS 17+). Bundle: `com.nulljosh.brief` · Team: `QMM486NPYC`

## Roadmap

- **Move case data behind Supabase auth** — `CaseData.swift` still hardcodes all case data (grounds, witnesses, lawyers, checklist, scripts). Migrate to `brief_config` table (already seeded). Add `BriefConfigDTOs.swift`, extend `Store.loadConfig()`, update all views to use `store.*` instead of globals. Matches web security model.
