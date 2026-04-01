# Dose
v1.3.0

## Rules
- Portfolio vibe design (Geist font, flat monochrome + blue accent, no shadows/gradients)
- Mobile-first, bottom nav, safe-area-inset support
- No backend -- localStorage only
- Interaction checker must warn when logging substance that interacts with active stack
- No emojis

## Run
```bash
npm run dev       # Dev server
npm test          # Run tests
npm run build     # Production build
git push           # Deploy (auto via Vercel Git integration from apps monorepo)
```

## Key Files
- src/App.jsx: App shell with routing, theme toggle, and navigation.
- src/main.jsx: React entry point that mounts the app and global styles.
- src/pages/Dashboard.jsx: Dashboard view for active stack and recent dose entries.
- src/components/InteractionChecker.jsx: Interaction checker logic and UI.
- src/data/substances.js: Substance dataset with harm reduction notes and interactions.
