# Brief

v6.0.0 — Cross-platform litigation tool. Web + iOS + macOS. Private.

## Cases
- **CASE-0001**: Trommel v. AG Canada (Charter rights)
- **CASE-0002**: Trommel v. Trommel (family tort)

## Structure

```
brief/
  web/        Vanilla JS PWA — heyitsmejosh.com/brief
  ios/        SwiftUI iOS 17+
  macos/      SwiftUI macOS 14+
  CaseData.json  canonical data reference (per-platform copies are authoritative)
```

See `web/CLAUDE.md` and `ios/CLAUDE.md` for platform-specific details.

## Auth

Supabase project: `spark` (shared with spark app). jatrommel@gmail.com only.
Biometric lock on iOS/macOS via `BiometricAuth.swift`.

## Deploy

Web auto-deploys to nulljosh.github.io/brief on push. No manual step.
