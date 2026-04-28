<img src="icon.svg" width="80">

# Dose
![version](https://img.shields.io/badge/version-v1.3.0-blue)
Personal substance tracker, harm reduction wiki, and health dashboard.

## Features
- Dose logging with journal, filters, search
- 200+ substance wiki with harm reduction data
- Drug interaction checker against active stack
- Tolerance tracking with washout period alerts
- Daily health check-ins and biometrics
- Usage heatmap, frequency stats, insights
- CSV export, fully offline (localStorage)

## Run
```bash
npm install && npm run dev   # localhost:5173
npm test
npm run build
vercel --prod
```

## Roadmap
- [ ] Custom substance creation
- [ ] Mood and sleep correlation with Apple Health sync
- [ ] OCR pill identification
- [ ] Lab PDF parsing — import bloodwork PDFs, parse values, flag out-of-range
- [ ] iOS companion app — log doses, view active stack, interaction warnings natively
- [ ] Reflexology and breathing modules (expansion from harm reduction into general wellness)

## Changelog
v1.3.0
- Portfolio vibe: Geist font, flat monochrome palette, spring animations, no shadows.

v1.1.0
- Added dose logging with journal, filters, and search.
- Built the substance wiki with harm reduction data and interaction checking.
- Shipped health check-ins, biometrics, insights, and offline CSV export.

## License
MIT 2026 Joshua Trommel
