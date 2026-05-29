# school — Claude Notes

## Overview
Grade 12 academic tracker. Web dashboard at school.heyitsmejosh.com + SwiftUI iOS app. Tracks Pre-Calculus 12 (units 1–7) and A&P 12 (units 1–9).

## Status (2026-05-29)
- Theme is device-auto across web + iOS/macOS (live `prefers-color-scheme`; no manual toggle). Low-ink print button (grayscale `@media print`) on index, masterclass, cram pages + native print in iOS Study view.

- Pre-Calc 12: Unit 4 active in class (May 26). Module 1 exam rewrite today 3–6pm. Self-study at Unit 7. Module tests remaining.
- Biology/A&P 12: all 9 units complete, all projects submitted. Done.
- Applications: CapU Paralegal Studies (applying 2026). UBC Law (after CapU).
- UVic CS BSc: postponed indefinitely.

## Dev
```bash
python3 -m http.server 8080   # web
cd ios && xcodegen generate && open School.xcodeproj   # iOS
```

## Deploy
```bash
git push origin main   # Vercel auto-deploy (nulljosh/school)
```

## Key Files
- `index.html` — static web dashboard (hardcoded data)
- `ios/Views/GradesView.swift` — live D2L grades via /api/grades
- `ios/Views/QuizView.swift` — multiple choice quiz flow
- `ios/Views/PlanView.swift` — applications + PC12 unit progress
- `ios/Models/Models.swift` — GradesPayload, QuizData, Subject enum
- `ios/Services/APIService.swift` — fetches /api/grades and /api/quizzes
- `api/grades.json` — grade data (update manually after D2L check)

## Rules
- No emojis
- index.html is static — update hardcoded data when grades or status change
- Subject.units in Models.swift must stay in sync with ~/Documents/School/ folder structure
