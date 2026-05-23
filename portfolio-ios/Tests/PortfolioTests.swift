import XCTest
@testable import Portfolio

final class PortfolioTests: XCTestCase {
    @MainActor
    func testViewModelLoadsProjects() async {
        let vm = PortfolioViewModel()
        await vm.loadProjects()
        XCTAssertFalse(vm.projects.isEmpty)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func testProjectAccentColor() {
        let webProject = Project(id: "test", name: "Test", summary: "A test", tags: ["web"], version: nil, urlString: nil, iconSystemName: "globe")
        XCTAssertEqual(webProject.iconName, "globe")
    }

    func testProjectURL() {
        let project = Project(id: "test", name: "Test", summary: "A test", tags: [], version: "1.0", urlString: "https://example.com", iconSystemName: "star")
        XCTAssertNotNil(project.url)

        let noURL = Project(id: "test2", name: "Test2", summary: "No url", tags: [], version: nil, urlString: nil, iconSystemName: "star")
        XCTAssertNil(noURL.url)
    }
}
