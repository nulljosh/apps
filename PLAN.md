# Apps — Pending

## 1. Push uncommitted changes

## 2. Bump READMEs
Apps: dose, lingo, life, nimble, roost, browser, fuse, bhaddie, wiretext, nyc
- Read each app's code, rewrite README with accurate versions/features

## 3. Auto-translate (all web apps)
- `tools/translate.sh` — extracts strings, generates `locales/{lang}.json` via translate-shell
- `tools/i18n.js` — client loader: reads locale JSON, swaps elements with `data-i18n` attr
- Add language switcher (small dropdown, top-right) to each web app HTML
- Languages: en, fr, es, zh, ja, de, pt, ar
- Web targets: lingo, life, browser, nimble-web, nyc-web, bhaddie, wiretext, roost
- iOS targets: lingo-ios, life-ios, dose, nimble-ios (Localizable.strings)
- macOS targets: lingo-macos, wiretext-macos
