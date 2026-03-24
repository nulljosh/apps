import XCTest
@testable import Nimble

final class PreferencesTests: XCTestCase {
    func testDefaultPreferences() {
        let defaults = PreferencesData()
        XCTAssertEqual(defaults.theme, "orange")
        XCTAssertTrue(defaults.mathEnabled)
        XCTAssertFalse(defaults.launchOnStartup)
        XCTAssertFalse(defaults.centerWindow)
        XCTAssertTrue(defaults.defaultSuggestions)
    }

    func testPreferencesEncoding() throws {
        let prefs = PreferencesData(
            theme: "blue",
            mathEnabled: false,
            launchOnStartup: true,
            centerWindow: true,
            defaultSuggestions: false
        )
        let data = try JSONEncoder().encode(prefs)
        let decoded = try JSONDecoder().decode(PreferencesData.self, from: data)
        XCTAssertEqual(decoded.theme, "blue")
        XCTAssertFalse(decoded.mathEnabled)
        XCTAssertTrue(decoded.launchOnStartup)
        XCTAssertTrue(decoded.centerWindow)
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
            // Just verify these don't crash
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
