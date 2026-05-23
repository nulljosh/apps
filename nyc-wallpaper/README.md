<img src="icon.svg" width="80">

# NYC Wallpaper

![version](https://img.shields.io/badge/version-v1.0.0-blue)

macOS screen saver that loads the NYC colony sim in wallpaper mode. WebKit view pointed at nyc.heyitsmejosh.com with auto-wallpaper and autoplay enabled.

## Install

```bash
xcodegen generate
xcodebuild -scheme NYCWallpaper -configuration Release
# Copy NYCWallpaper.saver to ~/Library/Screen Savers/
# System Settings > Screen Saver > NYC Life
```

## How It Works

- Loads nyc.heyitsmejosh.com in a full-screen WKWebView
- Auto-enables wallpaper mode (no HUD) after 3 seconds
- Colonists run around doing quests with speech bubbles
- Self-sustaining -- no interaction needed
