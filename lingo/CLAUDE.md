# Lingo

## Rules

- No build process -- pure HTML/CSS/JS, static deploy
- Liquid glass UI (Apple design language), dark mode support
- Touch-friendly: minimum 44px tap targets
- All transitions under 300ms, 60fps animations
- PocketBase migration started but NOT working yet -- do not assume accounts/sync are functional

## Run

```bash
open index.html
```

## PocketBase (in progress, not verified)

```bash
./scripts/dev-pocketbase.sh
./scripts/setup-pocketbase-superuser.sh
```

Schema must be verified from CLI before any frontend sync work.
