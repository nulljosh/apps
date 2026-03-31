# pulse-ios
v1.0.0

SwiftUI iOS app. Interactive foot/hand reflexology maps, pulse points by meridian, symptom finder, session tracker.

## Rules
- iOS 17.0+, Swift 6.0
- xcodegen for project generation
- @Observable for state
- No emojis

## Run
```bash
xcodegen generate
open Pulse.xcodeproj
```

## Key Files
- Sources/PulseApp.swift: Entry point, TabView, splash
- Sources/Models/ReflexologyData.swift: 16 foot + 11 hand zones
- Sources/Models/PulseData.swift: 11 meridians, 35+ points
- Sources/Models/SymptomData.swift: 12 symptoms with cross-refs
- Sources/Models/SessionStore.swift: UserDefaults persistence
- Sources/Views/BodyMapView.swift: SVG path parser + interactive map
- Sources/Views/ReflexologyTab.swift: Foot/hand segmented view
- Sources/Views/MeridianListView.swift: Expandable meridian/point list
- Sources/Views/SymptomFinderView.swift: Symptom grid with results
- Sources/Views/SessionHistoryView.swift: Session log
