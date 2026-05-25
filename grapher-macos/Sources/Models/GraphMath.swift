import Foundation

// Evaluates y = f(x) expressions by substituting x and using NSExpression.
// Supports: +, -, *, /, ^, sin, cos, tan, sqrt, abs, log, ln, exp, pi, e
enum GraphMath {

    static func evaluate(_ expression: String, at x: Double) -> Double? {
        var expr = expression
            .trimmingCharacters(in: .whitespaces)
        if let range = expr.range(of: #"^y\s*=\s*"#, options: [.regularExpression, .caseInsensitive]) {
            expr = String(expr[range.upperBound...])
        }
        guard !expr.isEmpty else { return nil }

        let xStr = "(\(x))"
        expr = substituteX(in: expr, with: xStr)
        expr = expandPowers(in: expr)
        expr = expr.replacingOccurrences(of: "pi", with: "\(Double.pi)")
        expr = expr.replacingOccurrences(of: "e", with: "\(M_E)")
        expr = replaceMathFunctions(in: expr)

        guard let ns = try? NSExpression(format: expr),
              let result = ns.expressionValue(with: nil, context: nil) as? NSNumber
        else { return nil }

        let v = result.doubleValue
        return v.isNaN || v.isInfinite ? nil : v
    }

    static func computePoints(
        expression: String,
        xMin: Double,
        xMax: Double,
        steps: Int
    ) -> [(x: Double, y: Double?)] {
        guard steps > 1 else { return [] }
        let stride = (xMax - xMin) / Double(steps - 1)
        return (0..<steps).map { i in
            let x = xMin + Double(i) * stride
            return (x, evaluate(expression, at: x))
        }
    }

    private static func substituteX(in expr: String, with replacement: String) -> String {
        var result = ""
        let chars = Array(expr)
        var i = 0
        while i < chars.count {
            let c = chars[i]
            if c == "x" {
                let prevOK = i == 0 || !chars[i - 1].isLetter && !chars[i - 1].isNumber && chars[i - 1] != "_"
                let nextOK = i == chars.count - 1 || !chars[i + 1].isLetter && !chars[i + 1].isNumber && chars[i + 1] != "_"
                if prevOK && nextOK {
                    result += replacement
                    i += 1
                    continue
                }
            }
            result.append(c)
            i += 1
        }
        return result
    }

    private static func expandPowers(in expr: String) -> String {
        var s = expr
        while let caretRange = s.range(of: "^") {
            let before = String(s[..<caretRange.lowerBound])
            let after = String(s[caretRange.upperBound...])
            guard let (leftOp, leftStart) = extractRightmostOperand(from: before),
                  let (rightOp, rightEnd) = extractLeftmostOperand(from: after)
            else { break }
            if let base = Double(leftOp), let exp = Double(rightOp) {
                let val = pow(base, exp)
                let beforeLeft = String(before[..<leftStart])
                let afterRight = String(after[rightEnd...])
                s = beforeLeft + "(\(val))" + afterRight
            } else {
                let beforeLeft = String(before[..<leftStart])
                let afterRight = String(after[rightEnd...])
                s = beforeLeft + "(1)" + afterRight
            }
        }
        return s
    }

    private static func extractRightmostOperand(from s: String) -> (String, String.Index)? {
        guard !s.isEmpty else { return nil }
        let chars = Array(s)
        var i = chars.count - 1
        while i >= 0 && chars[i] == " " { i -= 1 }
        guard i >= 0 else { return nil }
        if chars[i] == ")" {
            var depth = 1
            i -= 1
            while i >= 0 && depth > 0 {
                if chars[i] == ")" { depth += 1 }
                else if chars[i] == "(" { depth -= 1 }
                i -= 1
            }
            let start = s.index(s.startIndex, offsetBy: i + 2)
            return (String(s[start...]), start)
        } else {
            while i >= 0 && (chars[i].isNumber || chars[i] == "." || chars[i] == "-" && i == 0) { i -= 1 }
            let start = s.index(s.startIndex, offsetBy: i + 1)
            return (String(s[start...]), start)
        }
    }

    private static func extractLeftmostOperand(from s: String) -> (String, String.Index)? {
        guard !s.isEmpty else { return nil }
        let chars = Array(s)
        var i = 0
        while i < chars.count && chars[i] == " " { i += 1 }
        guard i < chars.count else { return nil }
        if chars[i] == "(" {
            var depth = 1
            i += 1
            while i < chars.count && depth > 0 {
                if chars[i] == "(" { depth += 1 }
                else if chars[i] == ")" { depth -= 1 }
                if depth > 0 { i += 1 }
            }
            i += 1
            let end = s.index(s.startIndex, offsetBy: i)
            return (String(s[..<end]), end)
        } else {
            let start = i
            if chars[i] == "-" { i += 1 }
            while i < chars.count && (chars[i].isNumber || chars[i] == ".") { i += 1 }
            let end = s.index(s.startIndex, offsetBy: i)
            return (String(s[s.index(s.startIndex, offsetBy: start)..<end]), end)
        }
    }

    private static func replaceMathFunctions(in expr: String) -> String {
        var s = expr
        let fns: [(String, (Double) -> Double)] = [
            ("sin", sin), ("cos", cos), ("tan", tan), ("sqrt", sqrt),
            ("abs", abs), ("log", log10), ("ln", log), ("exp", exp),
            ("floor", floor), ("ceil", ceil), ("round", { $0.rounded() }),
        ]
        for (name, fn) in fns {
            s = evaluateFunctionCalls(name: name, fn: fn, in: s)
        }
        return s
    }

    private static func evaluateFunctionCalls(name: String, fn: (Double) -> Double, in expr: String) -> String {
        var s = expr
        var searchFrom = s.startIndex
        while let range = s.range(of: name + "(", range: searchFrom..<s.endIndex) {
            let afterOpen = range.upperBound
            var depth = 1
            var i = afterOpen
            while i < s.endIndex && depth > 0 {
                if s[i] == "(" { depth += 1 }
                else if s[i] == ")" { depth -= 1 }
                if depth > 0 { i = s.index(after: i) }
            }
            guard depth == 0 else { break }
            let closeIndex = i
            let innerExpr = String(s[afterOpen..<closeIndex])
            if let innerVal = tryNumericEval(innerExpr) {
                let val = fn(innerVal)
                let replacement = "(\(val.isNaN || val.isInfinite ? "0" : String(val)))"
                let replRange = range.lowerBound..<s.index(after: closeIndex)
                s.replaceSubrange(replRange, with: replacement)
                let newPos = s.distance(from: s.startIndex, to: range.lowerBound) + replacement.count
                searchFrom = s.index(s.startIndex, offsetBy: min(newPos, s.count))
            } else {
                searchFrom = s.index(after: range.lowerBound)
            }
        }
        return s
    }

    private static func tryNumericEval(_ expr: String) -> Double? {
        guard !expr.isEmpty else { return nil }
        var s = expr
        let fns: [(String, (Double) -> Double)] = [
            ("sin", sin), ("cos", cos), ("tan", tan), ("sqrt", sqrt),
            ("abs", abs), ("log", log10), ("ln", log), ("exp", exp),
            ("floor", floor), ("ceil", ceil), ("round", { $0.rounded() }),
        ]
        for (name, fn) in fns {
            s = evaluateFunctionCalls(name: name, fn: fn, in: s)
        }
        guard let ns = try? NSExpression(format: s),
              let val = ns.expressionValue(with: nil, context: nil) as? NSNumber
        else { return nil }
        let d = val.doubleValue
        return d.isNaN || d.isInfinite ? nil : d
    }
}
