import XCTest
@testable import GrapherMac

final class GrapherMacTests: XCTestCase {
    func testSinX() {
        let y = GraphMath.evaluate("sin(x)", at: 0)
        XCTAssertNotNil(y)
        XCTAssertEqual(y!, 0, accuracy: 0.001)
    }

    func testLinear() {
        let y = GraphMath.evaluate("2*x+1", at: 3)
        XCTAssertNotNil(y)
        XCTAssertEqual(y!, 7, accuracy: 0.001)
    }

    func testPower() {
        let y = GraphMath.evaluate("x^2", at: 4)
        XCTAssertNotNil(y)
        XCTAssertEqual(y!, 16, accuracy: 0.001)
    }

    func testCosine() {
        let y = GraphMath.evaluate("cos(x)", at: 0)
        XCTAssertNotNil(y)
        XCTAssertEqual(y!, 1, accuracy: 0.001)
    }

    func testEmptyReturnsNil() {
        let y = GraphMath.evaluate("", at: 1)
        XCTAssertNil(y)
    }

    func testEquationStore() {
        let store = EquationStore()
        let initialCount = store.equations.count
        store.add()
        XCTAssertEqual(store.equations.count, initialCount + 1)
    }
}
