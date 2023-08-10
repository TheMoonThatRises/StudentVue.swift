//
//  String+PercentEncoding.swift
//
//
//  Created by TheMoonThatRises on 3/9/23.
//

import Foundation

extension String {
    /// Percent encode if possible
    ///
    /// - Parameters:
    ///    - withAllowedCharacters: Set of characters to encode
    ///
    /// - Returns: String percent encoded with character set
    func percentEncoding(withAllowedCharacters: CharacterSet) -> String {
        self.addingPercentEncoding(withAllowedCharacters: withAllowedCharacters) ?? self
    }
}
