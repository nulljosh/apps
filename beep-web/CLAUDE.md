# Beep Web

Single-file PWA wrapper for compasscard.ca.

## Structure

- `index.html` — entire app (HTML + CSS + JS, no build step)
- `manifest.json` — PWA manifest
- `vercel.json` — SPA rewrite rule

## Notes

- iframe sandbox allows scripts/forms/navigation; cross-origin JS access is blocked by browser (expected)
- Progress bar uses a 3s timeout fallback since iframe load events fire but cross-origin title access fails silently
- `history[]` tracks URL stack for back button; resets on tab switch
- Offline detection via `frame.addEventListener('error')` — only fires for hard network failures

## Deploy

```sh
cd apps/beep-web && npx vercel --prod
```
