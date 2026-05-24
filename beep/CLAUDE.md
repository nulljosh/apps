# Beep

Native iOS app for the TransLink Compass card (Vancouver BC).

## Architecture

Hidden `WKWebView` in `BeepSession` acts as a headless browser — handles auth, CSRF tokens, and data extraction via JS injection. All UI is native SwiftUI; user never sees a web page except in the reload and AutoLoad payment sheets.

## Source Structure

```
Sources/
  BeepApp.swift               — @main entry point
  ContentView.swift           — auth state router (unknown/loggingIn → spinner, loggedOut → LoginView, loggedIn → MainTabView)
  Models/
    BeepSession.swift         — ObservableObject: checkAuthState, submitLogin, loadDashboard, loadTrips, refresh, signOut
    BeepExtractor.swift       — JS scripts: isLoggedIn, cardInfoJSON, tripsJSONAsync, fillLogin, loginErrorMessage, fillReloadAmount
    CompassCard.swift         — CardInfo, TripRecord, AuthState structs
    KeychainManager.swift     — Keychain read/write/delete for credentials
    BiometricAuth.swift       — LAContext wrapper (Face ID / Touch ID)
    WebViewActions.swift      — goBack/reload closures for BeepWebView
  Views/
    LoginView.swift           — native SwiftUI form + Face ID button
    DashboardView.swift       — balance card (AutoLoad tappable), reload picker, recent trips preview
    TripsView.swift           — List of TripRecord rows
    AccountView.swift         — card info, AutoLoad toggle button, open in Safari, sign out
    ReloadSheetView.swift     — webview sheet for /LoadValue (payment); accepts prefilled amount
    AutoLoadSheetView.swift   — webview sheet for /AutoLoad settings
    BeepWebView.swift         — UIViewRepresentable WKWebView; accepts optional setupScript injected at documentEnd
```

## Auth Flow

1. App launch → `checkAuthState()` loads `/` in hidden webview, evaluates `isLoggedIn` JS
2. If logged in → `loadDashboard()` + `loadTrips()` → MainTabView
3. If not logged in and Keychain has credentials → Face ID prompt; on pass, `submitLogin()` with stored creds (no LoginView flash)
4. If biometric fails or no credentials → `LoginView` (native SwiftUI form)
5. Manual login → `submitLogin()`: loads `/SignIn`, injects JS to fill + submit form, waits for navigation, checks URL
6. On success → credentials saved to Keychain, dashboard + trips loaded, MainTabView shown

## Key Decisions

- **Content world**: All `evaluateJavaScript` and `callAsyncJavaScript` calls use `.defaultClient` isolated world. compasscard.ca's CSP blocks scripts in `.page` world; `.defaultClient` bypasses CSP while retaining full DOM read/write access and React/Angular event listener compatibility. Requires iOS 16+.
- **SPA trip polling**: `tripsJSONAsync` uses `callAsyncJavaScript` with top-level `await` to poll `table tbody tr` every 200ms up to 5s (25 attempts). compasscard.ca renders the trips table asynchronously after `didFinish`; sync evaluation always returns empty.
- **FIFO continuation queue**: `WebNavDelegate` maintains `[CheckedContinuation<Void, Never>]`. Single-slot continuation was overwritten by concurrent `waitForLoad()` calls, causing "continuation leaked" warnings and -999 cancellations. FIFO queue drains one per `didFinish`/`didFail`.
- **Reload flow**: Native amount picker (ReloadPickerView: $10/$20/$50/$100/custom) before presenting the /LoadValue webview. `fillReloadAmount()` JS is injected via `BeepWebView.setupScript` at document end.
- `WKWebsiteDataStore.default()` shared across hidden webview and payment sheets → cookies/session persist
- JS form fill uses native `HTMLInputElement.prototype.value` setter to trigger framework change detection
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
- AutoLoad: https://www.compasscard.ca/AutoLoad
- Account: https://www.compasscard.ca/MyAccount
