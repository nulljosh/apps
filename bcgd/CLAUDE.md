# BC Garage Doors (BCGD)
v3.0.0

Monorepo for BC Garage Doors -- customer-facing website, internal operations dashboard, and native companion apps.

## Structure
- `web/` -- Static HTML landing page. Conversion-focused, emergency-first. Live: bcgd.heyitsmejosh.com
- `dashboard/` -- Vite + React 19 operations dashboard. Inventory, jobs pipeline, PIN auth, backup/restore. Live: bcgd-dashboard.heyitsmejosh.com
- `ios/` -- (planned) SwiftUI iPhone companion app
- `macos/` -- (planned) SwiftUI macOS companion app

## Stack
- **web/**: Static HTML, no build step
- **dashboard/**: Vite + React 19, localStorage persistence, Animate.css, Apple Liquid Glass design

## Features
- Inventory management (28 SKUs, 6 categories, +/- qty controls)
- Low-stock alerts with reorder email (mailto)
- Browser notifications on stock threshold crossing
- PIN authentication gate (4-digit, localStorage)
- Job pipeline tracker (Lead -> Quote -> Scheduled -> Complete -> Paid)
- Backup/restore (JSON export/import)
- Stock change history with audit trail
- CSV export
- Settings (alert email, PIN, backup)

## Deploy
```bash
# Landing page
cd web && npx vercel --prod

# Dashboard
cd dashboard && npm run build && npx vercel --prod
```

## Dev
```bash
cd dashboard && npm install && npm run dev    # Vite on :5180
```

## Rules
- No emojis
- No gradients or drop shadows
- Spring physics on interactive elements: cubic-bezier(0.34, 1.56, 0.64, 1)
- Mobile-first, Apple Liquid Glass design system

## Roadmap

### iOS App (planned)
SwiftUI, iPhone 17 Pro target, iOS 17+. Four tabs:
- **Dashboard**: stats cards, low stock alerts, job stats (mirrors web)
- **Inventory**: part list with +/- qty controls, search, category filter
- **Jobs**: pipeline list with status badges, advance button, create/edit
- **Settings**: PIN, alert email, backup/restore

Data sync via shared API endpoint or standalone localStorage equivalent.
Located at `ios/` with xcodegen project.yml.

### macOS App (planned)
SwiftUI, macOS 14+. Same 4 tabs but sidebar navigation layout.
- Cmd+K search shortcut
- Native notifications for low stock alerts
- Keyboard shortcuts matching web (Alt+1-5 nav)

Located at `macos/` with xcodegen project.yml.

### Future
- Quick-quote calculator (door size + spring type + labor = estimate)
- Customer service history (name, address, work done, when)
- Estimate funnel engine (CTA tracking)
- Missed-call recovery autopilot
