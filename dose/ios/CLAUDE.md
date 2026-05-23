# Dose

v2.1.0

## Rules

- iOS 17+, SwiftUI only, @Observable, @Bindable
- xcodegen (project.yml), no checked-in .xcodeproj
- HealthKit entitlements via Dose.entitlements
- App Group: group.com.heyitsmejosh.dose (widget data sync)
- UserDefaults persistence, no backend
- no emojis

## Run

```bash
xcodegen generate && open Dose.xcodeproj
xcodebuild -scheme Dose build
xcodebuild -scheme Dose test
```

## Key Files

- DoseApp.swift: app entry point with tab layout, splash, and biometric lock flow
- Services/DataStore.swift: UserDefaults persistence, widget sync, and import/export bundle
- Services/HealthKitService.swift: HealthKit authorization and metric fetching
- Services/InteractionEngine.swift: interaction classification for built-in substances
- Views/DashboardView.swift: home dashboard for active stack and recent entries
