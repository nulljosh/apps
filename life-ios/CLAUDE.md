# Josh (Life iOS)

Native SwiftUI companion for the Life therapy document.

## Structure
- `LifeApp.swift` -- Entry point
- `Models/LifeData.swift` -- All content hardcoded as static data; TimelineCategory has color/displayName computed properties
- `Views/ContentView.swift` -- Main scroll view
- `Views/TimelineView.swift` -- Vertical timeline with category dots, legend driven by TimelineCategory.allCases
- `Views/SectionCardView.swift` -- Reusable section card

## Notes
- Private, sensitive content. Same as web version.
- All data is static. No networking, no persistence.
- iOS 17+, @Observable not needed (no mutable state)
- xcodegen for project generation
- Test target uses GENERATE_INFOPLIST_FILE
