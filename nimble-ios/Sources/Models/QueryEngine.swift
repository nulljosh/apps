import Foundation

struct WebResult: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    let snippet: String
    var domain: String {
        (try? URL(string: url).map { $0.host?.replacingOccurrences(of: "www.", with: "") ?? "" }) ?? ""
    }
}

struct DDGResponse: Codable {
    let abstractText: String?
    let abstractSource: String?
    let abstractURL: String?
    let answer: String?
    let answerType: String?
    let definition: String?
    let definitionSource: String?
    let definitionURL: String?
    let heading: String?
    let image: String?
    let relatedTopics: [DDGTopic]?

    enum CodingKeys: String, CodingKey {
        case abstractText = "AbstractText"
        case abstractSource = "AbstractSource"
        case abstractURL = "AbstractURL"
        case answer = "Answer"
        case answerType = "AnswerType"
        case definition = "Definition"
        case definitionSource = "DefinitionSource"
        case definitionURL = "DefinitionURL"
        case heading = "Heading"
        case image = "Image"
        case relatedTopics = "RelatedTopics"
    }
}

struct DDGTopic: Codable {
    let text: String?
    let firstURL: String?
    let topics: [DDGSubTopic]?

    enum CodingKeys: String, CodingKey {
        case text = "Text"
        case firstURL = "FirstURL"
        case topics = "Topics"
    }
}

struct DDGSubTopic: Codable {
    let text: String?
    let firstURL: String?

    enum CodingKeys: String, CodingKey {
        case text = "Text"
        case firstURL = "FirstURL"
    }
}

struct WikiResponse: Codable {
    let title: String?
    let extract: String?
    let thumbnail: WikiThumbnail?
    let contentUrls: WikiContentURLs?

    enum CodingKeys: String, CodingKey {
        case title, extract, thumbnail
        case contentUrls = "content_urls"
    }
}

struct WikiThumbnail: Codable {
    let source: String?
}

struct WikiContentURLs: Codable {
    let desktop: WikiDesktopURL?
}

struct WikiDesktopURL: Codable {
    let page: String?
}

final class QueryEngine: Sendable {
    private static let suggestions: [String] = {
        guard let url = Bundle.main.url(forResource: "suggestions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let arr = try? JSONDecoder().decode([String].self, from: data) else {
            return defaultSuggestions
        }
        return arr
    }()

    private static let defaultSuggestions = [
        "256 / 8",
        "How big is the Atlantic Ocean?",
        "Distance from Earth to Mars",
        "Population of Canada",
        "Speed of light in km/h",
        "What is the meaning of life?",
        "21st digit of pi?",
        "Convert 100 Fahrenheit to Celsius",
        "GDP of Japan",
        "Who founded Apple?",
        "Atomic weight of gold",
        "How far is the moon?",
        "Binary representation of 255"
    ]

    func evaluateMath(_ input: String) -> String? {
        var expr = input.trimmingCharacters(in: .whitespaces)
        guard !expr.isEmpty else { return nil }

        // Try natural language math first ("whats nine plus ten" -> "9 + 10")
        if let nlExpr = parseNaturalLanguageMath(expr) {
            if let result = evaluateNumericExpression(nlExpr) {
                return result
            }
        }

        // Reject natural language: strip math tokens, check what's left
        var testStr = expr.lowercased()
        let mathFunctions = ["sqrt", "sin", "cos", "tan", "log", "ln", "abs", "pow", "mod", "pi"]
        for fn in mathFunctions {
            testStr = testStr.replacingOccurrences(of: fn, with: "")
        }
        // After removing math functions, only math chars should remain
        let mathAllowed = CharacterSet(charactersIn: "0123456789.+-*/^%() ,eE")
            .union(.whitespaces)
        let isLikelyMath = testStr.unicodeScalars.allSatisfy { mathAllowed.contains($0) }
        if !isLikelyMath { return nil }

        // Reject if it's just a bare number with no operation
        let hasOperation = expr.contains(where: { "+-*/^%".contains($0) })
            || mathFunctions.contains(where: { expr.lowercased().contains($0 + "(") })
            || expr.lowercased() == "pi" || expr.lowercased() == "e"
        guard hasOperation else { return nil }

        // Pre-process constants
        expr = expr.replacingOccurrences(of: "\\bpi\\b", with: String(Double.pi), options: .regularExpression)
        if expr.lowercased() == "e" { return formatResult(M.E) }

        // Try function evaluator first (sqrt, sin, cos, tan, log, ln, abs, pow)
        if let funcResult = evaluateWithFunctions(expr) {
            return formatResult(funcResult)
        }

        // Fall back to NSExpression for basic arithmetic
        let cleaned = expr
            .replacingOccurrences(of: "x", with: "*")
            .replacingOccurrences(of: "X", with: "*")
            .replacingOccurrences(of: "^", with: "**")

        // NSExpression doesn't support %, handle modulo manually
        if cleaned.contains("%") {
            let parts = cleaned.components(separatedBy: "%")
            if parts.count == 2,
               let lhs = evaluateSimple(parts[0].trimmingCharacters(in: .whitespaces)),
               let rhs = evaluateSimple(parts[1].trimmingCharacters(in: .whitespaces)),
               rhs != 0 {
                return formatResult(lhs.truncatingRemainder(dividingBy: rhs))
            }
            return nil
        }

        // Validate remaining chars
        let validChars = CharacterSet(charactersIn: "0123456789.+-*/(). ")
        let isValid = cleaned.unicodeScalars.allSatisfy { validChars.contains($0) }
        guard isValid else { return nil }

        // Force floating point by ensuring at least one number has a decimal
        let floatCleaned = cleaned.replacingOccurrences(
            of: #"\b(\d+)\b"#,
            with: "$1.0",
            options: .regularExpression
        )

        let expression = NSExpression(format: floatCleaned)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return formatResult(result.doubleValue)
        }

        return nil
    }

    private func evaluateWithFunctions(_ input: String) -> Double? {
        let expr = input.trimmingCharacters(in: .whitespaces)

        // sqrt(x)
        if let match = expr.range(of: #"sqrt\((.+)\)"#, options: .regularExpression) {
            let inner = String(expr[match]).replacingOccurrences(of: "sqrt(", with: "").dropLast()
            if let val = evaluateSimple(String(inner)) {
                return sqrt(val)
            }
        }

        // sin(x), cos(x), tan(x) -- radians
        for (name, fn) in [("sin", sin), ("cos", cos), ("tan", tan)] as [(String, (Double) -> Double)] {
            let pattern = "\(name)\\((.+)\\)"
            if let match = expr.range(of: pattern, options: .regularExpression) {
                let inner = String(expr[match]).replacingOccurrences(of: "\(name)(", with: "").dropLast()
                if let val = evaluateSimple(String(inner)) {
                    return fn(val)
                }
            }
        }

        // log(x) = log10, ln(x) = natural log
        if let match = expr.range(of: #"ln\((.+)\)"#, options: .regularExpression) {
            let inner = String(expr[match]).replacingOccurrences(of: "ln(", with: "").dropLast()
            if let val = evaluateSimple(String(inner)) {
                return log(val)
            }
        }
        if let match = expr.range(of: #"log\((.+)\)"#, options: .regularExpression) {
            let inner = String(expr[match]).replacingOccurrences(of: "log(", with: "").dropLast()
            if let val = evaluateSimple(String(inner)) {
                return log10(val)
            }
        }

        // abs(x)
        if let match = expr.range(of: #"abs\((.+)\)"#, options: .regularExpression) {
            let inner = String(expr[match]).replacingOccurrences(of: "abs(", with: "").dropLast()
            if let val = evaluateSimple(String(inner)) {
                return abs(val)
            }
        }

        // x^y (power)
        if expr.contains("^") {
            let parts = expr.components(separatedBy: "^")
            if parts.count == 2, let base = evaluateSimple(parts[0].trimmingCharacters(in: .whitespaces)),
               let exp = evaluateSimple(parts[1].trimmingCharacters(in: .whitespaces)) {
                return pow(base, exp)
            }
        }

        return nil
    }

    private func evaluateSimple(_ expr: String) -> Double? {
        // Try direct double parse
        if let val = Double(expr) { return val }

        // Try NSExpression
        let cleaned = expr.replacingOccurrences(of: "x", with: "*").replacingOccurrences(of: "X", with: "*")
        let expression = NSExpression(format: cleaned)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return result.doubleValue
        }
        return nil
    }

    private func formatResult(_ value: Double) -> String {
        if value.isNaN || value.isInfinite { return String(value) }
        if value == value.rounded() && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        // Up to 10 decimal places, trim trailing zeros
        let formatted = String(format: "%.10f", value)
        let trimmed = formatted.replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
        return trimmed
    }

    private enum M {
        static let E = 2.718281828459045
    }

    func query(_ input: String) async -> QueryResult {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: config)

        async let ddg = queryDDG(input, session: session)
        async let wiki = queryWikipedia(input, session: session)

        if let ddgResult = await ddg { return ddgResult }
        if let wikiResult = await wiki { return wikiResult }

        let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? input
        return .error("No instant answer found.", searchURL: "https://duckduckgo.com/?q=\(encoded)")
    }

    private func queryDDG(_ input: String, session: URLSession = .shared) async -> QueryResult? {
        guard let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.duckduckgo.com/?q=\(encoded)&format=json&no_html=1&skip_disambig=1") else {
            return nil
        }

        do {
            let (data, _) = try await session.data(from: url)
            let ddg = try JSONDecoder().decode(DDGResponse.self, from: data)

            if let abstract = ddg.abstractText, !abstract.isEmpty {
                let source = ddg.abstractSource ?? "DuckDuckGo"
                let sourceURL = ddg.abstractURL
                let imageURL = ddg.image.flatMap { $0.isEmpty ? nil : "https://duckduckgo.com\($0)" }
                return .text(heading: ddg.heading, body: abstract, source: source, sourceURL: sourceURL, imageURL: imageURL)
            }

            if let answer = ddg.answer, !answer.isEmpty {
                // Strip HTML tags from answer
                let clean = answer.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                return .text(heading: nil, body: clean, source: "DuckDuckGo", sourceURL: nil, imageURL: nil)
            }

            if let definition = ddg.definition, !definition.isEmpty {
                return .text(heading: ddg.heading, body: definition, source: ddg.definitionSource ?? "DuckDuckGo", sourceURL: ddg.definitionURL, imageURL: nil)
            }

            if let topics = ddg.relatedTopics, !topics.isEmpty {
                var items: [String] = []
                for topic in topics.prefix(5) {
                    if let text = topic.text, !text.isEmpty {
                        items.append(text)
                    }
                    if let subs = topic.topics {
                        for sub in subs.prefix(2) {
                            if let text = sub.text, !text.isEmpty {
                                items.append(text)
                            }
                        }
                    }
                }
                if !items.isEmpty {
                    return .list(items: items, source: "DuckDuckGo")
                }
            }

            return nil
        } catch {
            return nil
        }
    }

    private func queryWikipedia(_ input: String, session: URLSession = .shared) async -> QueryResult? {
        // First try direct page summary
        let searchTerm = input.replacingOccurrences(of: " ", with: "_")
        if let encoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
           let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encoded)"),
           let result = await fetchWikiSummary(url: url, session: session) {
            return result
        }

        // Fall back to Wikipedia search API to find the right article
        guard let searchEncoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let searchURL = URL(string: "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(searchEncoded)&format=json&srlimit=1") else {
            return nil
        }

        do {
            let (data, _) = try await session.data(from: searchURL)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let query = json["query"] as? [String: Any],
               let search = query["search"] as? [[String: Any]],
               let first = search.first,
               let title = first["title"] as? String {
                let articleTitle = title.replacingOccurrences(of: " ", with: "_")
                guard let titleEncoded = articleTitle.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                      let summaryURL = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(titleEncoded)") else {
                    return nil
                }
                return await fetchWikiSummary(url: summaryURL, session: session)
            }
        } catch {}

        return nil
    }

    private func fetchWikiSummary(url: URL, session: URLSession = .shared) async -> QueryResult? {
        guard let url = Optional(url) else { return nil }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            let wiki = try JSONDecoder().decode(WikiResponse.self, from: data)
            guard let extract = wiki.extract, !extract.isEmpty else { return nil }

            return .text(
                heading: wiki.title,
                body: extract,
                source: "Wikipedia",
                sourceURL: wiki.contentUrls?.desktop?.page,
                imageURL: wiki.thumbnail?.source
            )
        } catch {
            return nil
        }
    }

    private static let wordNumbers: [String: String] = [
        "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
        "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
        "ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13",
        "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
        "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30",
        "forty": "40", "fifty": "50", "sixty": "60", "seventy": "70",
        "eighty": "80", "ninety": "90", "hundred": "100", "thousand": "1000",
        "million": "1000000"
    ]

    private static let wordOperators: [String: String] = [
        "plus": "+", "add": "+", "added to": "+",
        "minus": "-", "subtract": "-", "less": "-",
        "times": "*", "multiplied by": "*", "x": "*",
        "divided by": "/", "over": "/",
        "to the power of": "^", "squared": "^2", "cubed": "^3"
    ]

    private static let fillerPatterns = [
        "what is ", "whats ", "what's ", "calculate ", "how much is ",
        "compute ", "solve ", "evaluate ", "the answer to ", "result of "
    ]

    func parseNaturalLanguageMath(_ input: String) -> String? {
        var text = input.lowercased().trimmingCharacters(in: .whitespaces)

        // Must contain at least one word-number and one word-operator
        let hasWordNumber = Self.wordNumbers.keys.contains(where: { text.contains($0) })
        let hasWordOp = Self.wordOperators.keys.contains(where: { text.contains($0) })
        guard hasWordNumber && hasWordOp else { return nil }

        // Strip filler
        for filler in Self.fillerPatterns {
            if text.hasPrefix(filler) {
                text = String(text.dropFirst(filler.count))
            }
        }
        text = text.replacingOccurrences(of: "?", with: "").trimmingCharacters(in: .whitespaces)

        // Replace multi-word operators first
        for (word, op) in Self.wordOperators.sorted(by: { $0.key.count > $1.key.count }) {
            text = text.replacingOccurrences(of: word, with: " \(op) ")
        }

        // Replace word numbers
        for (word, num) in Self.wordNumbers {
            text = text.replacingOccurrences(of: "\\b\(word)\\b", with: num, options: .regularExpression)
        }

        // Clean up whitespace
        text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)

        // Verify it looks like a math expression now
        let mathChars = CharacterSet(charactersIn: "0123456789.+-*/^%() ").union(.whitespaces)
        let isMath = text.unicodeScalars.allSatisfy { mathChars.contains($0) }
        guard isMath else { return nil }

        return text
    }

    private func evaluateNumericExpression(_ expr: String) -> String? {
        // Reuse existing evaluateMath logic on the converted expression
        var e = expr
        e = e.replacingOccurrences(of: "\\bpi\\b", with: String(Double.pi), options: .regularExpression)

        if let funcResult = evaluateWithFunctions(e) {
            return formatResult(funcResult)
        }

        let cleaned = e
            .replacingOccurrences(of: "^", with: "**")
        let validChars = CharacterSet(charactersIn: "0123456789.+-*/(). ")
        let isValid = cleaned.unicodeScalars.allSatisfy { validChars.contains($0) }
        guard isValid else { return nil }

        let floatCleaned = cleaned.replacingOccurrences(
            of: #"\b(\d+)\b"#, with: "$1.0", options: .regularExpression
        )

        let expression = NSExpression(format: floatCleaned)
        if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
            return formatResult(result.doubleValue)
        }
        return nil
    }

    func randomSuggestion(useDefaults: Bool) -> String {
        let pool = useDefaults ? Self.suggestions : Self.defaultSuggestions
        return pool.randomElement() ?? "Search anything..."
    }

    func fetchWebResults(_ query: String) async -> [WebResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://nimble.heyitsmejosh.com/api/search?q=\(encoded)&limit=10") else {
            return []
        }
        do {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 8
            let session = URLSession(configuration: config)
            let (data, _) = try await session.data(from: url)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]] else { return [] }
            return results.compactMap { r in
                guard let title = r["title"] as? String,
                      let url = r["url"] as? String else { return nil }
                let snippet = r["snippet"] as? String ?? ""
                return WebResult(title: title, url: url, snippet: snippet)
            }
        } catch {
            return []
        }
    }
}
