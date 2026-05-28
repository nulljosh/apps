import XCTest

final class PreviewScreenshot: XCTestCase {
    func testCapturePreview() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(2)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "preview"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
