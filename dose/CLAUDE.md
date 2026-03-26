# Dose
v1.2.0

## Rules
- Dark Editorial / BC gov blue variant design
- Mobile-first, bottom nav, safe-area-inset support
- No backend -- localStorage only
- Interaction checker must warn when logging substance that interacts with active stack
- No emojis

## Run
```bash
npm run dev       # Dev server
npm test          # Run tests
npm run build     # Production build
vercel --prod     # Deploy
```

## Key Files
- src/App.jsx: App shell with routing, theme toggle, and navigation.
- src/main.jsx: React entry point that mounts the app and global styles.
- src/pages/Dashboard.jsx: Dashboard view for active stack and recent dose entries.
- src/components/InteractionChecker.jsx: Interaction checker logic and UI.
- src/data/substances.js: Substance dataset with harm reduction notes and interactions.
