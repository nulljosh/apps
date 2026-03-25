import XCTest
@testable import Life

final class LifeiOSTests: XCTestCase {
    func testTimelineHasEntries() {
        XCTAssertEqual(LifeData.timeline.count, 11)
    }

    func testSectionsHaveContent() {
        XCTAssertEqual(LifeData.sections.count, 18)
        for section in LifeData.sections {
            XCTAssertFalse(section.label.isEmpty)
            XCTAssertFalse(section.paragraphs.isEmpty)
            for p in section.paragraphs {
                XCTAssertFalse(p.isEmpty)
            }
        }
    }

    func testAllCategoriesPresent() {
        let categories = Set(LifeData.timeline.map(\.category))
        XCTAssertTrue(categories.contains(.crisis))
        XCTAssertTrue(categories.contains(.event))
        XCTAssertTrue(categories.contains(.forward))
    }
}
