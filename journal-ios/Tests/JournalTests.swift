import XCTest
@testable import JournalIOS

final class JournalTests: XCTestCase {
    func testAtomParserExtractsEntries() throws {
        let xml = """
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom">
          <title type="html">nulljosh</title>
          <entry>
            <title type="html">Case Three</title>
            <link href="https://journal.heyitsmejosh.com/2026/05/30/week/" rel="alternate" type="text/html"/>
            <published>2026-05-30T13:00:00-07:00</published>
            <id>https://journal.heyitsmejosh.com/2026/05/30/week</id>
            <content type="html"><![CDATA[<p>Body text.</p>]]></content>
          </entry>
        </feed>
        """
        let posts = try AtomParser().parse(Data(xml.utf8))
        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(posts.first?.title, "Case Three")
        XCTAssertEqual(posts.first?.url?.absoluteString,
                       "https://journal.heyitsmejosh.com/2026/05/30/week/")
        XCTAssertNotNil(posts.first?.published)
        XCTAssertTrue(posts.first?.contentHTML.contains("Body text.") ?? false)
    }

    func testExcerptStripsHTML() {
        let post = Post(id: "1", title: "T", url: nil, published: nil,
                        contentHTML: "<p>Hello <strong>world</strong></p>")
        XCTAssertEqual(post.excerpt, "Hello world")
    }
}
