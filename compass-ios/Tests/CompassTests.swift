import XCTest
@testable import CompassIOS

final class CompassTests: XCTestCase {
    func testTabURLs() {
        XCTAssertEqual(CompassTab.home.url.host, "www.compasscard.ca")
        XCTAssertEqual(CompassTab.reload.url.path, "/LoadValue")
        XCTAssertEqual(CompassTab.trips.url.path, "/CardUse")
        XCTAssertEqual(CompassTab.account.url.path, "/MyAccount")
    }
}
