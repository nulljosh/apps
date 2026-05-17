<img src="icon.svg" width="80">

# brief-macos

![v1.1.0](https://img.shields.io/badge/version-1.1.0-blue) ![macOS 14](https://img.shields.io/badge/macOS-14%2B-black) ![Swift 6](https://img.shields.io/badge/Swift-6-orange)

Native macOS litigation planning tool for *Trommel v. AG Canada*. NavigationSplitView sidebar with Case, Money, and Actions panels.

## Features

- Full parity with iOS: facts, witnesses, grounds, journal (add/edit/delete), checklist, lawyer status cycling
- Supabase magic link auth with cross-platform DB sync (journal, checklist, lawyer statuses)
- Follows system dark/light automatically

## Stack

SwiftUI · macOS 14+ · Swift 6 · xcodegen

## Build

```bash
cd apps/brief/macos && xcodegen generate && open Brief.xcodeproj
```

Bundle: `com.nulljosh.brief-macos` · Team: `QMM486NPYC`

## Platforms

- Web: [heyitsmejosh.com/brief](https://heyitsmejosh.com/brief)
- iOS: `apps/brief/ios/`
- macOS: `apps/brief/macos/`

## Roadmap

- **Move case data behind Supabase auth** — `CaseData.swift` still hardcodes all case data. Migrate to `brief_config` table (already seeded). Add `BriefConfigDTOs.swift`, extend `Store.loadConfig()`, update all views to use `store.*`. Matches web security model.
