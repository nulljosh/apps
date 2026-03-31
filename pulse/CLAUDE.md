# pulse
v1.1.0

## Rules

- Mobile-first, Dark Editorial BC gov blue variant
- Navy #0c1220, blue #1a5a96/#2472b2/#4e9cd7, Fraunces + DM Sans
- SVG body maps are inline React components with clickable zones
- No emojis

## Run

```bash
npm install && npm run dev
npm run build
```

## Key Files

- src/main.jsx: App bootstrap
- src/App.jsx: Routing
- src/components/FootMap.jsx: Interactive foot SVG with 16 zones
- src/components/HandMap.jsx: Interactive hand SVG with 11 zones
- src/components/ZoneDetail.jsx: Zone info panel
- src/data/reflexology.js: Foot and hand zone data
- src/data/pulse.js: 11 meridians, 35+ points
- src/data/symptoms.js: 12 symptom conditions with linked zones/points
- src/context/SessionContext.jsx: Session tracking with localStorage
- src/pages/: Home, Feet, Hands, Pulse, Symptoms, History
