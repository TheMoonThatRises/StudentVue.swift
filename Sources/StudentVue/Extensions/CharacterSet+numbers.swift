//
//  CharacterSet+numbers.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/18/23.
//

import Foundation

extension CharacterSet {
    /// A `CharacterSet` disallowing all numerical values.
    internal static let numbers = CharacterSet(charactersIn: "0123456789").inverted

    /// A `CharacterSet` disallowing all numerical values along with some other symbols.
    internal static let numbersextended = CharacterSet(charactersIn: "0123456789/-.").inverted
}
