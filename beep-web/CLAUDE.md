# Beep Web

Single-file launcher PWA for compasscard.ca.

## Structure

- `index.html` — entire app (HTML + CSS, no JS, no build step)
- `manifest.json` — PWA manifest
- `vercel.json` — SPA rewrite rule

## Notes

- NOT an iframe wrapper. compasscard.ca is behind Imperva/Incapsula (`X-Iinfo` header) and
  serves a JS challenge that sets a `SameSite=None` cookie. Inside an iframe that is a
  third-party cookie, which Safari blocks by default (ITP), so the challenge never passes
  and the frame stays stuck on "Request unsuccessful." The iframe approach is dead.
- Instead Beep is a launcher: Liquid Glass screen with `<a target="_blank">` links to the
  four Compass pages. In a standalone PWA these open in Safari (first-party context), where
  the challenge passes and login works.
- Native `beep` iOS app can still embed because WKWebView gets first-party cookies; the web
  cannot replicate that cross-origin.

## Deploy

```sh
cd apps/beep-web && npx vercel --prod
```
