import Foundation

enum CodeNormalizer {
    static func normalizeToTsCode(_ input: String) -> String? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if trimmed.contains(".") {
            return trimmed.uppercased()
        }

        // Common A-share heuristics:
        // 6xxxxx -> SH, 0/3xxxxx -> SZ, 8/4xxxxx -> BJ
        if trimmed.count == 6, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed)) {
            if trimmed.hasPrefix("6") { return "\(trimmed).SH" }
            if trimmed.hasPrefix("0") || trimmed.hasPrefix("3") { return "\(trimmed).SZ" }
            if trimmed.hasPrefix("8") || trimmed.hasPrefix("4") { return "\(trimmed).BJ" }
        }

        return nil
    }

    static func splitBatch(_ text: String) -> [String] {
        text
            .replacingOccurrences(of: ",", with: "\n")
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
