//
//  String+replacing.swift
//
//
//  Created by TheMoonThatRises on 8/9/23.
//

import Foundation

extension String {
    /// Replace substring with another substring in the current string
    ///
    /// - Parameters:
    ///    - from: Substring of characters to replace
    ///    - with: Substring of replacing characters
    ///
    /// - Returns: String with substring replaced
    public func replacing(_ from: String, with: String) -> Self {
        self.replacingOccurrences(of: from, with: with)
    }
}
