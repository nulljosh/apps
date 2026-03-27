# Joshua Adam Trommel (Life iOS)

Native SwiftUI companion for the Life therapy document.

## Structure
- `LifeApp.swift` -- Entry point
- `Models/LifeData.swift` -- All content hardcoded as static data; models for timeline, sections, charts, stats, map locations
- `Views/ContentView.swift` -- Paging scroll view with text sections + visual pages combined
- `Views/TimelineView.swift` -- Vertical timeline with category dots, legend driven by TimelineCategory.allCases
- `Views/SectionCardView.swift` -- Reusable section card
- `Views/ChartsView.swift` -- All chart views (10 Swift Charts + pull quotes + stats grid + map)

## Visual Elements
Charts: StabilityChart, EventsBarChart, AggressionChart, TriggersChart, DiagnosisGapChart, RelationshipChart, SocialCircleChart, HousingChart, CopingChart, DailyRoutineChart
Other: PullQuoteView, StatsGridView, LifeMapView
Helper: chartTitle() -- shared title styling

## Page Layout
- Each page fills viewport height via containerRelativeFrame(.vertical)
- Text sections paired with related visuals on the same page (sectionWithVisual)
- Standalone visual pages use combinedPage for pull quote + chart pairs
- Paging scroll behavior (.scrollTargetBehavior(.paging))

## Notes
- Private, sensitive content. Same as web version.
- All data is static. No networking, no persistence.
- iOS 17+, @Observable not needed (no mutable state)
- xcodegen for project generation
- Test target uses GENERATE_INFOPLIST_FILE
- Charts use explicit chartXScale domains to prevent axis compression
