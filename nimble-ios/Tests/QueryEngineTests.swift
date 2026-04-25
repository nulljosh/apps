import XCTest
@testable import NimbleIOS

final class QueryEngineTests: XCTestCase {
    let engine = QueryEngine()

    // MARK: - Basic arithmetic

    func testBasicAddition() {
        XCTAssertEqual(engine.evaluateMath("2 + 2"), "4")
    }

    func testMultiplication() {
        XCTAssertEqual(engine.evaluateMath("6 * 7"), "42")
    }

    func testDivision() {
        XCTAssertEqual(engine.evaluateMath("100 / 4"), "25")
    }

    func testSubtraction() {
        XCTAssertEqual(engine.evaluateMath("100 - 37"), "63")
    }

    func testDecimalResult() {
        let result = engine.evaluateMath("10 / 3")
        XCTAssertNotNil(result)
        let val = Double(result!)
        XCTAssertNotNil(val)
        XCTAssertEqual(val!, 10.0 / 3.0, accuracy: 0.0001)
    }

    func testComplexExpression() {
        XCTAssertEqual(engine.evaluateMath("(10 + 5) * 2"), "30")
    }

    func testNegativeNumbers() {
        let result = engine.evaluateMath("5 - 10")
        XCTAssertEqual(result, "-5")
    }

    func testModulo() {
        XCTAssertEqual(engine.evaluateMath("17 % 5"), "2")
    }

    // MARK: - Advanced math

    func testPower() {
        XCTAssertEqual(engine.evaluateMath("2^10"), "1024")
    }

    func testSqrt() {
        XCTAssertEqual(engine.evaluateMath("sqrt(144)"), "12")
    }

    func testSinZero() {
        XCTAssertEqual(engine.evaluateMath("sin(0)"), "0")
    }

    func testCosZero() {
        XCTAssertEqual(engine.evaluateMath("cos(0)"), "1")
    }

    func testLog10() {
        XCTAssertEqual(engine.evaluateMath("log(100)"), "2")
    }

    func testAbs() {
        XCTAssertEqual(engine.evaluateMath("abs(-42)"), "42")
    }

    // MARK: - Non-math rejection

    func testNonMathReturnsNil() {
        XCTAssertNil(engine.evaluateMath("hello world"))
    }

    func testEmptyReturnsNil() {
        XCTAssertNil(engine.evaluateMath(""))
    }

    func testSentenceReturnsNil() {
        XCTAssertNil(engine.evaluateMath("what is the population of canada"))
    }

    func testSingleNumberReturnsNil() {
        XCTAssertNil(engine.evaluateMath("42"))
    }

    // MARK: - Suggestions

    func testRandomSuggestion() {
        let suggestion = engine.randomSuggestion(useDefaults: true)
        XCTAssertFalse(suggestion.isEmpty)
    }

    func testRandomSuggestionNoDefaults() {
        let suggestion = engine.randomSuggestion(useDefaults: false)
        XCTAssertFalse(suggestion.isEmpty)
    }

    // MARK: - Network queries

    func testDDGQuery() async {
        let result = await engine.query("define nimble")
        switch result {
        case .text, .list:
            break
        case .error:
            break // network may not be available
        default:
            XCTFail("Expected text, list, or error result")
        }
    }
}
