import Foundation

struct CardInfo: Equatable {
    var balance: String
    var cardNumber: String
    var autoLoadEnabled: Bool
}

struct TripRecord: Identifiable {
    var id = UUID()
    var date: String
    var location: String
    var product: String
    var amount: String
    var balance: String
}

enum AuthState: Equatable {
    case unknown
    case loggedOut
    case loggingIn
    case loggedIn(CardInfo)
}
