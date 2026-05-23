import Foundation

@MainActor
final class WebViewActions: ObservableObject {
    var goBack: (() -> Void)?
    var reload: (() -> Void)?
}
