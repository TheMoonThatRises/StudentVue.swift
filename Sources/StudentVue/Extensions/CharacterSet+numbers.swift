//
//  CharacterSet+numbers.swift
//  
//
//  Created by TheMoonThatRises on 3/18/23.
//

import Foundation

extension CharacterSet {
    public static let numbers = CharacterSet(charactersIn: "0123456789").inverted

    public static let numbersextended = CharacterSet(charactersIn: "0123456789/-.").inverted
}
