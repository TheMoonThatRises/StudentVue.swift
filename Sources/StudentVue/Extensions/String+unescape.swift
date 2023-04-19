//
//  String+unescape.swift
//  
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation

extension String {
    /// Unescapes left and right angle brackets
    var unescape: String {
        let characters = [
//            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">"
//            "&quot;": "\\\"",
//            "&apos;": "'"
        ]
        var str = self
        for (escaped, unescaped) in characters {
            str = str.replacingOccurrences(of: escaped, with: unescaped, options: .literal, range: nil)
        }
        return str
    }
}
