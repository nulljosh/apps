# Journal (macOS)

![icon](icon.svg) v1.0.1

App display name **Journal** (Xcode target: `JournalMac`). SwiftUI reader for journal.heyitsmejosh.com. Shares the iOS sources; pulls the
live Atom feed (`/feed.xml`) and renders posts in a styled WebView. No bundled
content: empty state until the feed loads.

Build: `xcodegen generate && open JournalMac.xcodeproj`
