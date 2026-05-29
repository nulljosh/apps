# Journal (macOS)

Native SwiftUI reader for the journal.heyitsmejosh.com blog. App display name is **Journal** (`PRODUCT_NAME`/`CFBundleDisplayName`); the Xcode project/target is still `JournalMac`.

## Architecture
- `Sources/Services/FeedStore.swift` — fetches the live Atom feed (`https://journal.heyitsmejosh.com/feed.xml`) over `URLSession`, parses it with `AtomParser` (NSXMLParser delegate). No bundled/seed content: `posts` is empty until the network load completes.
- `Sources/Models/Post.swift` — post model (id, title, url, published, contentHTML).
- `Sources/Views/PostDetailView.swift` + `HTMLView.swift` — render each post's CDATA HTML in a styled WebView.
- `Sources/ContentView.swift` — post list, pull-to-refresh, error/empty states.

The iOS and macOS targets share identical `FeedStore`/`Post`/parser logic.

## Build / run
```bash
cd apps/journal-macos
xcodegen generate
xcodebuild -project JournalMac.xcodeproj -scheme JournalMac -configuration Debug build
open <derived-data>/Build/Products/Debug/Journal.app
```

## Notes
- Icon: `Assets.xcassets/AppIcon.appiconset` holds a full macOS icon set (16–512 @1x/@2x) rasterized from `icon.svg`.
- The feed URL is stable across the planned GitHub Pages -> Vercel host migration (both serve `/feed.xml`), so no app change is needed when DNS flips.
- Dynamic only — never hardcode posts. The blog is the single source of truth.
