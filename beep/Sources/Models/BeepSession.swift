import Foundation
import WebKit

@MainActor
final class BeepSession: ObservableObject {
    @Published var authState: AuthState = .unknown
    @Published var cardInfo: CardInfo?
    @Published var trips: [TripRecord] = []
    @Published var isRefreshing = false

    let hiddenWebView: WKWebView
    private let navDelegate = WebNavDelegate()

    init() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        hiddenWebView = WKWebView(frame: .zero, configuration: config)
        hiddenWebView.navigationDelegate = navDelegate
    }

    func checkAuthState() async {
        await loadPage(URL(string: "https://www.compasscard.ca/")!)
        let loggedIn = await evalJS(BeepExtractor.isLoggedIn) as? Bool ?? false
        if loggedIn {
            await loadDashboard()
            return
        }
        // Auto-login with Keychain + biometrics — no LoginView flash
        if KeychainManager.hasCredentials,
           await BiometricAuth.authenticate(),
           let creds = try? KeychainManager.loadCredentials() {
            let result = await submitLogin(email: creds.email, password: creds.password)
            if case .success = result { return }
        }
        authState = .loggedOut
    }

    func submitLogin(email: String, password: String) async -> Result<Void, LoginError> {
        authState = .loggingIn
        await loadPage(URL(string: "https://www.compasscard.ca/SignIn")!)
        _ = await evalJS(BeepExtractor.fillLogin(email: email, password: password))
        await navDelegate.waitForLoad()
        let url = hiddenWebView.url?.absoluteString ?? ""
        if url.lowercased().contains("signin") {
            authState = .loggedOut
            let msg = await evalJS(BeepExtractor.loginErrorMessage) as? String
            return .failure(LoginError(message: msg?.isEmpty == false ? msg! : "Invalid email or password."))
        }
        await loadDashboard()
        await loadTrips()
        return .success(())
    }

    func loadDashboard() async {
        isRefreshing = true
        defer { isRefreshing = false }
        guard let jsonStr = await evalJS(BeepExtractor.cardInfoJSON) as? String,
              let data = jsonStr.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
        let info = CardInfo(
            balance: json["balance"] as? String ?? "--",
            cardNumber: json["cardNumber"] as? String ?? "",
            autoLoadEnabled: json["autoLoad"] as? Bool ?? false
        )
        cardInfo = info
        authState = .loggedIn(info)
    }

    func loadTrips() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }
        await loadPage(URL(string: "https://www.compasscard.ca/CardUse")!)
        if let jsonStr = await callAsyncJS(BeepExtractor.tripsJSONAsync) as? String,
           let data = jsonStr.data(using: .utf8),
           let rows = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] {
            trips = rows.map {
                TripRecord(date: $0["date"] ?? "", location: $0["location"] ?? "",
                           product: $0["product"] ?? "", amount: $0["amount"] ?? "",
                           balance: $0["balance"] ?? "")
            }
        }
        await loadPage(URL(string: "https://www.compasscard.ca/")!)
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }
        await loadPage(URL(string: "https://www.compasscard.ca/")!)
        await loadDashboard()
        await loadTrips()
    }

    func signOut() async {
        KeychainManager.deleteCredentials()
        let store = WKWebsiteDataStore.default()
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let records = await store.dataRecords(ofTypes: types)
        await store.removeData(ofTypes: types, for: records)
        cardInfo = nil
        trips = []
        authState = .loggedOut
    }

    private func evalJS(_ script: String) async -> Any? {
        await withCheckedContinuation { (cont: CheckedContinuation<Any?, Never>) in
            hiddenWebView.evaluateJavaScript(script, in: nil, in: .defaultClient) { result in
                cont.resume(returning: try? result.get())
            }
        }
    }

    private func callAsyncJS(_ body: String) async -> Any? {
        await withCheckedContinuation { (cont: CheckedContinuation<Any?, Never>) in
            hiddenWebView.callAsyncJavaScript(body, arguments: [:], in: nil, in: .defaultClient) { value, _ in
                cont.resume(returning: value)
            }
        }
    }

    private func loadPage(_ url: URL) async {
        hiddenWebView.load(URLRequest(url: url))
        await navDelegate.waitForLoad()
    }
}

@MainActor
final class WebNavDelegate: NSObject, WKNavigationDelegate {
    private var continuations: [CheckedContinuation<Void, Never>] = []

    func waitForLoad() async {
        await withCheckedContinuation { cont in
            continuations.append(cont)
        }
    }

    nonisolated func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        Task { @MainActor in self.resume() }
    }

    nonisolated func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        Task { @MainActor in self.resume() }
    }

    nonisolated func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) {
        Task { @MainActor in self.resume() }
    }

    private func resume() {
        guard !continuations.isEmpty else { return }
        continuations.removeFirst().resume()
    }
}
