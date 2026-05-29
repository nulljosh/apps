# Journal (iOS)

Native SwiftUI reader for the journal.heyitsmejosh.com blog.

## Architecture
- `Sources/Services/FeedStore.swift` — fetches the live Atom feed (`https://journal.heyitsmejosh.com/feed.xml`) over `URLSession`, parses it with `AtomParser` (NSXMLParser delegate). No bundled/seed content: `posts` is empty until the network load completes.
- `Sources/Models/Post.swift` — post model (id, title, url, published, contentHTML).
- `Sources/Views/PostDetailView.swift` + `HTMLView.swift` — render each post's CDATA HTML in a styled WebView.
- `Sources/ContentView.swift` — post list, pull-to-refresh, error/empty states.

The iOS and macOS targets share identical `FeedStore`/`Post`/parser logic.

## Build / run
```bash
cd apps/journal-ios
xcodegen generate
xcodebuild -project JournalIOS.xcodeproj -scheme JournalIOS \
  -destination "id=<sim-udid>" -configuration Debug build
# install + launch: xcrun simctl install <sim> <app>; xcrun simctl launch <sim> com.nulljosh.journal-ios
```

## Notes
- The feed URL is stable across the planned GitHub Pages -> Vercel host migration (both serve `/feed.xml`), so no app change is needed when DNS flips.
- Dynamic only — never hardcode posts. The blog is the single source of truth.
