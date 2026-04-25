# Portfolio iOS

Native SwiftUI portfolio viewer for heyitsmejosh.com.

## Structure
- `PortfolioApp.swift` -- Entry point with splash screen
- `Models/Project.swift` -- Project data model (Codable, Identifiable)
- `Models/PortfolioViewModel.swift` -- @Observable view model, static project data
- `Views/ContentView.swift` -- Tab switching between projects list and web view
- `Views/ProjectCardView.swift` -- Glass-style project card with FlowLayout tags
- `Views/PortfolioWebView.swift` -- WKWebView wrapper for full site
- `Views/SplashView.swift` -- Launch splash
- `API/PortfolioAPI.swift` -- HTML fetch helper for future use

## Notes
- iOS 17+, SwiftUI, @Observable, @MainActor
- Project data is currently static; API layer ready for future dynamic loading
- xcodegen for project generation
- Bundle ID: com.heyitsmejosh.portfolio-ios
