import Foundation

/// Loads and exposes the journal feed. No bundled content: the list is empty
/// until the live Atom feed at journal.heyitsmejosh.com loads.
@MainActor
final class FeedStore: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    static let feedURL = URL(string: "https://journal.heyitsmejosh.com/feed.xml")!
    static let siteURL = URL(string: "https://journal.heyitsmejosh.com")!

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            var request = URLRequest(url: Self.feedURL)
            request.cachePolicy = .reloadRevalidatingCacheData
            let (data, _) = try await URLSession.shared.data(for: request)
            posts = try AtomParser().parse(data)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

/// Minimal Atom feed parser for the jekyll-feed output. Captures entry-level
/// title, alternate link, published date, id, and CDATA HTML content.
final class AtomParser: NSObject, XMLParserDelegate {
    private var posts: [Post] = []
    private var inEntry = false
    private var element = ""
    private var buffer = ""
    private var title = ""
    private var link: String?
    private var published = ""
    private var id = ""
    private var content = ""

    nonisolated(unsafe) private static let dateParser: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    func parse(_ data: Data) throws -> [Post] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else {
            throw parser.parserError ?? URLError(.cannotParseResponse)
        }
        return posts
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes attributeDict: [String: String]) {
        element = elementName
        buffer = ""
        if elementName == "entry" {
            inEntry = true
            title = ""; link = nil; published = ""; id = ""; content = ""
        }
        if inEntry, elementName == "link",
           attributeDict["rel"] == "alternate", let href = attributeDict["href"] {
            link = href
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        buffer += string
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if let string = String(data: CDATABlock, encoding: .utf8) {
            buffer += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName: String?) {
        guard inEntry else { return }
        let value = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
        switch elementName {
        case "title": title = value
        case "published": published = value
        case "id": id = value
        case "content": content = buffer
        case "entry":
            inEntry = false
            posts.append(
                Post(
                    id: id.isEmpty ? UUID().uuidString : id,
                    title: title,
                    url: link.flatMap(URL.init(string:)),
                    published: Self.dateParser.date(from: published),
                    contentHTML: content
                )
            )
        default:
            break
        }
    }
}
