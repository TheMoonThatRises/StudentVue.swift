//
//  String+replacing.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/9/23.
//

import Foundation

extension String {
    /// Replace substring with another substring in the current string.
    ///
    /// - Parameters:
    ///    - from: Substring of characters to replace.
    ///    - with: Substring of replacing characters.
    ///
    /// - Returns: String with substring replaced.
    internal func replacing(_ from: String, with: String) -> Self {
        self.replacingOccurrences(of: from, with: with)
    }

    /// Matches current string with a regex and returns all matches.
    ///
    /// This function is taken from
    /// [https://stackoverflow.com/a/34460111](https://stackoverflow.com/a/34460111).
    ///
    /// - Parameter regex: Regex to match the current string.
    ///
    /// - Returns: An array of matched strings.
    internal func matches(_ regex: String) -> [Self] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            return []
        }
    }
}
