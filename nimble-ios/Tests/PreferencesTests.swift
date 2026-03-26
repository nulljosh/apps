import XCTest
@testable import NimbleIOS

final class PreferencesTests: XCTestCase {
    func testDefaultPreferences() {
        let defaults = PreferencesData()
        XCTAssertEqual(defaults.theme, "orange")
        XCTAssertTrue(defaults.mathEnabled)
        XCTAssertTrue(defaults.defaultSuggestions)
    }

    func testPreferencesEncoding() throws {
        let prefs = PreferencesData(
            theme: "blue",
            mathEnabled: false,
            defaultSuggestions: false
        )
        let data = try JSONEncoder().encode(prefs)
        let decoded = try JSONDecoder().decode(PreferencesData.self, from: data)
        XCTAssertEqual(decoded.theme, "blue")
        XCTAssertFalse(decoded.mathEnabled)
        XCTAssertFalse(decoded.defaultSuggestions)
    }

    func testThemeAllCases() {
        XCTAssertEqual(NimbleTheme.allCases.count, 8)
        for theme in NimbleTheme.allCases {
            XCTAssertFalse(theme.displayName.isEmpty)
        }
    }

    func testThemeColors() {
        for theme in NimbleTheme.allCases {
            _ = theme.color
            _ = theme.backgroundColor
            _ = theme.textColor
            _ = theme.inputTextColor
        }
    }

    func testQueryResultEquatable() {
        XCTAssertEqual(QueryResult.none, QueryResult.none)
        XCTAssertEqual(QueryResult.loading, QueryResult.loading)
        XCTAssertEqual(QueryResult.math("42"), QueryResult.math("42"))
        XCTAssertNotEqual(QueryResult.math("42"), QueryResult.math("43"))
        XCTAssertNotEqual(QueryResult.none, QueryResult.loading)
    }
}
