# Brief

v6.2.0 — Cross-platform litigation tool. Web + iOS + macOS. Private.

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

`apps/brief/web/` is the canonical source. The live site (`heyitsmejosh.com/brief`) is a
deploy-only mirror inside the `nulljosh.github.io` repo (GitHub Pages, legacy mode — Actions are
disabled account-wide, so no CI deploy).

**Auto-deploy:** a git **pre-push hook** in this repo (`apps/.git/hooks/pre-push`) runs
`brief/web/deploy.sh` whenever `brief/web/` changed in the pushed commits. So a normal
`git push` of `apps` (manual, or via `auto-commit-watcher`) updates the live site automatically.
`deploy.sh` is idempotent (content fingerprint), auto-bumps the cache version (`?v=N` +
`CACHE='brief-vN'`, kept equal), runs `node --check` as a syntax gate, then commits + pushes the
portfolio repo.

**Manual deploy:** `bash apps/brief/web/deploy.sh` (same logic, run standalone).

The hook lives in `.git/hooks` (machine-local, not version-controlled). If this repo is recloned,
reinstall it or just run `deploy.sh` manually. Hand-editing `nulljosh.github.io/brief/` is wrong —
it gets overwritten. Drift between the two copies caused the May 2026 "version 6 reverted to 1"
regression; the hook exists to prevent a recurrence.
