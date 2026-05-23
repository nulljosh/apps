# Beep

Native iOS app for the TransLink Compass card (Vancouver BC).

## Architecture

Hidden `WKWebView` in `BeepSession` acts as a headless browser — handles auth, CSRF tokens, and data extraction via JS injection. All UI is native SwiftUI; user never sees a web page.

## Source Structure

```
Sources/
  BeepApp.swift               — @main entry point
  ContentView.swift           — auth state router (unknown/loggingIn → spinner, loggedOut → LoginView, loggedIn → MainTabView)
  Models/
    BeepSession.swift         — ObservableObject: checkAuthState, submitLogin, loadDashboard, loadTrips, refresh, signOut
    BeepExtractor.swift       — JS scripts: isLoggedIn, cardInfoJSON, tripsJSON, fillLogin, loginErrorMessage
    CompassCard.swift         — CardInfo, TripRecord, AuthState structs
    KeychainManager.swift     — Keychain read/write/delete for credentials
    BiometricAuth.swift       — LAContext wrapper (Face ID / Touch ID)
    WebViewActions.swift      — goBack/reload closures for BeepWebView
  Views/
    LoginView.swift           — native SwiftUI form + Face ID button
    DashboardView.swift       — balance card, reload button, recent trips preview
    TripsView.swift           — List of TripRecord rows
    AccountView.swift         — card info, open in Safari, sign out
    ReloadSheetView.swift     — webview sheet for /LoadValue (payment)
    BeepWebView.swift         — UIViewRepresentable WKWebView (used by ReloadSheetView only)
```

## Auth Flow

1. App launch → `checkAuthState()` loads `/` in hidden webview, evaluates `isLoggedIn` JS
2. Logged in → `loadDashboard()` + lazy `loadTrips()` → MainTabView
3. Not logged in → `LoginView` (native SwiftUI form)
4. Sign in → `submitLogin()`: loads `/SignIn` in hidden webview, injects JS to fill + submit form, waits for navigation, checks URL
5. On success → credentials saved to Keychain, data loaded, MainTabView shown
6. Next launch → Face ID prompt auto-fires if credentials in Keychain; on pass, calls `submitLogin()` with stored creds

## Key Decisions

- `WKWebsiteDataStore.default()` shared across hidden webview and ReloadSheetView → cookies/session persist
- JS form fill uses native `HTMLInputElement.prototype.value` setter to trigger framework change detection
- `WebNavDelegate` continuation pattern: `withCheckedContinuation` setup is synchronous, so no race between `evaluateJavaScript` returning and `didFinish` firing
- Keychain uses `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` for password

## JS Selectors (tune if extraction fails)

After logging in on device, open Safari → Settings → Advanced → Web Inspector, connect to device, inspect compasscard.ca DOM and update selectors in `BeepExtractor.swift`.

## Build

```sh
xcodegen generate
open Beep.xcodeproj
```

## URLs

- Dashboard: https://www.compasscard.ca/
- Trips: https://www.compasscard.ca/CardUse
- Reload: https://www.compasscard.ca/LoadValue
- Account: https://www.compasscard.ca/MyAccount
