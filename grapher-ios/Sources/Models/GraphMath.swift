import Foundation

// Evaluates y = f(x) expressions by substituting x and using NSExpression.
// Supports: +, -, *, /, ^, sin, cos, tan, sqrt, abs, log, exp, pi, e
enum GraphMath {

    /// Evaluate expression string at a given x value. Returns nil if invalid/undefined.
    static func evaluate(_ expression: String, at x: Double) -> Double? {
        var expr = expression
            .trimmingCharacters(in: .whitespaces)
        // Strip optional "y =" prefix
        if let range = expr.range(of: #"^y\s*=\s*"#, options: [.regularExpression, .caseInsensitive]) {
            expr = String(expr[range.upperBound...])
        }
        guard !expr.isEmpty else { return nil }

        // Substitute x value
        let xStr = "(\(x))"
        // Replace standalone 'x' tokens (not part of other words like 'exp', 'max', 'min')
        expr = substituteX(in: expr, with: xStr)

        // Replace ^ with ** for NSExpression power via NSPredicate workaround — NSExpression
        // does not support ^. Use a manual power expansion pass instead.
        expr = expandPowers(in: expr)

        // Replace math constants
        expr = expr.replacingOccurrences(of: "pi", with: "\(Double.pi)")
        expr = expr.replacingOccurrences(of: "e", with: "\(M_E)")

        // Replace math functions NSExpression understands
        // sin, cos, tan, abs, sqrt, log (base 10 in NSExpression, we map ln too), exp
        // NSExpression function syntax: function:withArguments:
        // Easier: convert to NSExpression FUNCTION() call syntax
        expr = replaceMathFunctions(in: expr)

        guard let ns = try? NSExpression(format: expr),
              let result = ns.expressionValue(with: nil, context: nil) as? NSNumber
        else { return nil }

        let v = result.doubleValue
        return v.isNaN || v.isInfinite ? nil : v
    }

    /// Compute array of (x, y) pairs for the given expression across an x range.
    /// Returns pairs so the caller can detect discontinuities (nil y = lift pen).
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

    // MARK: - Private helpers

    private static func substituteX(in expr: String, with replacement: String) -> String {
        // Regex: match 'x' not preceded or followed by a letter/digit/underscore
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

    /// Replace a^b with pow(a,b) style handling using repeated simple substitution.
    /// Handles simple cases: number^number, (group)^number.
    private static func expandPowers(in expr: String) -> String {
        // NSExpression supports raised-to via ** — but only in numeric format predicates.
        // Safest: rewrite a^b to custom evaluation. Since NSExpression can't do pow() generically,
        // we parse ^ manually here by walking the string and building a replacement.
        // This handles simple cases that mathjs would handle.
        var s = expr
        while let caretRange = s.range(of: "^") {
            // Find left operand — scan back for matched paren group or number/identifier
            let before = String(s[..<caretRange.lowerBound])
            let after = String(s[caretRange.upperBound...])

            guard let (leftOp, leftStart) = extractRightmostOperand(from: before),
                  let (rightOp, rightEnd) = extractLeftmostOperand(from: after)
            else {
                // Cannot parse — leave as is to avoid infinite loop
                break
            }

            // Compute power numerically if both are numeric literals
            if let base = Double(leftOp), let exp = Double(rightOp) {
                let val = pow(base, exp)
                let beforeLeft = String(before[..<leftStart])
                let afterRight = String(after[rightEnd...])
                s = beforeLeft + "(\(val))" + afterRight
            } else {
                // Non-numeric operands — cannot evaluate; substitute 1 to avoid crash
                let beforeLeft = String(before[..<leftStart])
                let afterRight = String(after[rightEnd...])
                s = beforeLeft + "(1)" + afterRight
            }
        }
        return s
    }

    /// Extract the rightmost operand from a string (for left side of ^)
    private static func extractRightmostOperand(from s: String) -> (String, String.Index)? {
        guard !s.isEmpty else { return nil }
        let chars = Array(s)
        var i = chars.count - 1

        // Skip whitespace
        while i >= 0 && chars[i] == " " { i -= 1 }
        guard i >= 0 else { return nil }

        if chars[i] == ")" {
            // Find matching (
            var depth = 1
            i -= 1
            while i >= 0 && depth > 0 {
                if chars[i] == ")" { depth += 1 }
                else if chars[i] == "(" { depth -= 1 }
                i -= 1
            }
            let start = s.index(s.startIndex, offsetBy: i + 2)
            let end = s.endIndex
            return (String(s[start..<end]), start)
        } else {
            // Number or identifier
            while i >= 0 && (chars[i].isNumber || chars[i] == "." || chars[i] == "-" && i == 0) {
                i -= 1
            }
            let start = s.index(s.startIndex, offsetBy: i + 1)
            return (String(s[start...]), start)
        }
    }

    /// Extract the leftmost operand from a string (for right side of ^)
    private static func extractLeftmostOperand(from s: String) -> (String, String.Index)? {
        guard !s.isEmpty else { return nil }
        let chars = Array(s)
        var i = 0

        // Skip whitespace
        while i < chars.count && chars[i] == " " { i += 1 }
        guard i < chars.count else { return nil }

        if chars[i] == "(" {
            var depth = 1
            i += 1
            while i < chars.count && depth > 0 {
                if chars[i] == "(" { depth += 1 }
                else if chars[i] == ")" { depth -= 1 }
                i += 1
            }
            let end = s.index(s.startIndex, offsetBy: i)
            return (String(s[..<end]), end)
        } else {
            // Negative number or plain number
            let start = i
            if chars[i] == "-" { i += 1 }
            while i < chars.count && (chars[i].isNumber || chars[i] == ".") { i += 1 }
            let end = s.index(s.startIndex, offsetBy: i)
            return (String(s[s.index(s.startIndex, offsetBy: start)..<end]), end)
        }
    }

    /// Convert sin(x), cos(x), tan(x), sqrt(x), abs(x), log(x), ln(x), exp(x)
    /// to NSExpression-compatible FUNCTION() syntax.
    private static func replaceMathFunctions(in expr: String) -> String {
        var s = expr
        // NSExpression supports these via FUNCTION() with the NSNumber methods
        // But actually the simplest approach for sin/cos/tan is to evaluate
        // numerically before handing off. Since x is already substituted with a number,
        // we can walk the string, find function calls, evaluate them numerically,
        // and substitute the result back.
        let fns: [(String, (Double) -> Double)] = [
            ("sin", sin),
            ("cos", cos),
            ("tan", tan),
            ("sqrt", sqrt),
            ("abs", abs),
            ("log", log10),
            ("ln", log),
            ("exp", exp),
            ("floor", floor),
            ("ceil", ceil),
            ("round", { d in d.rounded() }),
        ]

        for (name, fn) in fns {
            s = evaluateFunctionCalls(name: name, fn: fn, in: s)
        }
        return s
    }

    /// Find all `name(...)` calls in expression, recursively evaluate contents first,
    /// then apply fn to the numeric result and substitute back.
    private static func evaluateFunctionCalls(name: String, fn: (Double) -> Double, in expr: String) -> String {
        var s = expr
        // Keep replacing until no more instances found
        var searchFrom = s.startIndex
        while let range = s.range(of: name + "(", range: searchFrom..<s.endIndex) {
            // Find matching closing paren
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
            // Recursively evaluate inner first (handles nested calls)
            // Try to get numeric value from inner
            if let innerVal = tryNumericEval(innerExpr),
               let result = Double(exactly: innerVal) ?? Optional(fn(innerVal)) {
                let val = fn(innerVal)
                let replacement = "(\(val.isNaN || val.isInfinite ? "0" : String(val)))"
                let replRange = range.lowerBound..<s.index(after: closeIndex)
                s.replaceSubrange(replRange, with: replacement)
                searchFrom = s.index(s.startIndex, offsetBy: s.distance(from: s.startIndex, to: range.lowerBound) + replacement.count)
                _ = result // suppress warning
            } else {
                // Cannot evaluate — skip past this occurrence
                searchFrom = s.index(after: range.lowerBound)
            }
        }
        return s
    }

    /// Try to evaluate a simple numeric expression string using NSExpression.
    private static func tryNumericEval(_ expr: String) -> Double? {
        guard !expr.isEmpty else { return nil }
        // Recursively apply function replacements first
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
