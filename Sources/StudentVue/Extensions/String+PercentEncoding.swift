//
//  String+PercentEncoding.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 3/9/23.
//

import Foundation

extension String {
    /// Percent encode `String.self` for an input of valid characters if possible.
    ///
    /// - Parameter withAllowedCharacters: Set of characters to encode.
    ///
    /// - Returns: String percent encoded with character set.
    internal func percentEncoding(withAllowedCharacters: CharacterSet) -> String {
        self.addingPercentEncoding(withAllowedCharacters: withAllowedCharacters) ?? self
    }
}
