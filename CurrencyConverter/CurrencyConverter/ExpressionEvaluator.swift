import Foundation

/// Evaluates simple arithmetic typed into a currency box, e.g. "12.5+3*2",
/// so a box can hold a running calculation instead of just a plain number.
/// Supports +, -, *, /, unary sign, and parentheses.
enum ExpressionEvaluator {
    static func evaluate(_ input: String) -> Double? {
        let characters = Array(input)
        guard !characters.isEmpty else { return nil }
        var index = 0

        func peek() -> Character? {
            index < characters.count ? characters[index] : nil
        }

        func parseNumber() -> Double? {
            let start = index
            if peek() == "-" || peek() == "+" { index += 1 }
            var sawDigit = false
            while let c = peek(), c.isNumber || c == "." {
                if c.isNumber { sawDigit = true }
                index += 1
            }
            guard sawDigit else { return nil }
            return Double(String(characters[start..<index]))
        }

        func parseFactor() -> Double? {
            if peek() == "(" {
                index += 1
                guard let value = parseExpression(), peek() == ")" else { return nil }
                index += 1
                return value
            }
            return parseNumber()
        }

        func parseTerm() -> Double? {
            guard var value = parseFactor() else { return nil }
            while let op = peek(), op == "*" || op == "/" {
                index += 1
                guard let rhs = parseFactor() else { return nil }
                if op == "*" {
                    value *= rhs
                } else {
                    guard rhs != 0 else { return nil }
                    value /= rhs
                }
            }
            return value
        }

        func parseExpression() -> Double? {
            guard var value = parseTerm() else { return nil }
            while let op = peek(), op == "+" || op == "-" {
                index += 1
                guard let rhs = parseTerm() else { return nil }
                value = op == "+" ? value + rhs : value - rhs
            }
            return value
        }

        guard let result = parseExpression(), index == characters.count else { return nil }
        return result
    }
}
