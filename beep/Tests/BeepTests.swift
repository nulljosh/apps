import XCTest
@testable import Beep

final class BeepTests: XCTestCase {
    func testCardInfoEquality() {
        let a = CardInfo(balance: "$10.00", cardNumber: "1234", autoLoadEnabled: false)
        let b = CardInfo(balance: "$10.00", cardNumber: "1234", autoLoadEnabled: false)
        XCTAssertEqual(a, b)
    }

    func testAuthStateEquality() {
        XCTAssertEqual(AuthState.loggedOut, AuthState.loggedOut)
        XCTAssertNotEqual(AuthState.loggedOut, AuthState.unknown)
        let info = CardInfo(balance: "$5.00", cardNumber: "1234", autoLoadEnabled: false)
        XCTAssertEqual(AuthState.loggedIn(info), AuthState.loggedIn(info))
        XCTAssertNotEqual(AuthState.loggedIn(info), AuthState.loggedOut)
    }

    func testTripRecordUniqueIDs() {
        let t1 = TripRecord(date: "May 1", location: "Waterfront", product: "1-Zone", amount: "-$2.50", balance: "$5.00")
        let t2 = TripRecord(date: "May 1", location: "Waterfront", product: "1-Zone", amount: "-$2.50", balance: "$5.00")
        XCTAssertNotEqual(t1.id, t2.id)
    }
}
