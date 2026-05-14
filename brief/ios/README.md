<img src="icon.svg" width="80">

# brief-ios

![v1.0.0](https://img.shields.io/badge/version-1.0.0-blue) ![iOS 17](https://img.shields.io/badge/iOS-17%2B-black) ![Swift 6](https://img.shields.io/badge/Swift-6-orange)

Native iOS litigation planning app for *Trommel v. AG Canada*. SwiftUI port of [heyitsmejosh.com/brief](https://heyitsmejosh.com/brief).

**Case:** Charter violations from warrantless wellness-call entry by Langley RCMP, August 1, 2023. 8 stacked grounds. $800k–$1.5M likely settlement range.

## Features

- Case tab: facts, witness statements with legal annotations, 8 Charter grounds accordion, pain journal (persistent)
- Money tab: outcome scenarios, per-head damage stack, Ward framework, comparable awards
- Actions tab: lawyer contacts with call/email, evidence checklist (persistent), call script + email template with copy/share, timeline, risks, drafts

## Build

```bash
cd apps/brief-ios
xcodegen generate
open Brief.xcodeproj
```

Run on iPhone simulator (iOS 17+).
