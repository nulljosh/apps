import XCTest
import SwiftUI
@testable import Life

final class LifeiOSTests: XCTestCase {
    func testTimelineHasEntries() {
        XCTAssertEqual(LifeData.timeline.count, 11)
    }

    func testSectionsHaveContent() {
        XCTAssertEqual(LifeData.sections.count, 32)
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

    func testCategoryColors() {
        XCTAssertEqual(TimelineCategory.crisis.color, .red)
        XCTAssertEqual(TimelineCategory.event.color, .primary)
        XCTAssertEqual(TimelineCategory.forward.color, .green)
    }

    func testCategoryDisplayNames() {
        XCTAssertEqual(TimelineCategory.crisis.displayName, "Crisis")
        XCTAssertEqual(TimelineCategory.event.displayName, "Event")
        XCTAssertEqual(TimelineCategory.forward.displayName, "Forward")
    }

    func testTimelineEntriesValid() {
        for entry in LifeData.timeline {
            XCTAssertFalse(entry.year.isEmpty, "Timeline entry has empty year")
            XCTAssertFalse(entry.text.isEmpty, "Timeline entry has empty text")
        }
    }

    func testSectionsWithNotesHaveContent() {
        let sectionsWithNotes = LifeData.sections.filter { $0.note != nil }
        XCTAssertFalse(sectionsWithNotes.isEmpty, "Expected at least one section with a note")
        for section in sectionsWithNotes {
            XCTAssertFalse(section.note!.isEmpty, "Section '\(section.label)' has empty note")
        }
    }
}
