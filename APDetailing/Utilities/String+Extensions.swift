//
//  String+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 1/18/23.
//

import Foundation

extension String {
    var numbersOnly: String { self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
}

extension String? {
    var isNotNilAndNotEmpty: Bool { self != nil && self != "" }
}

extension String {
    func formatPhoneNumber() -> String {
        // Remove any character that is not a number
        var numbersOnly = self.numbersOnly
        let length = numbersOnly.count
        
        // Check for supported phone number length
        if length > 10 && numbersOnly.hasPrefix("1") {
            numbersOnly.removeFirst()
            return numbersOnly.formatPhoneNumber()
        } else if length > 10 {
            return String(numbersOnly.prefix(10)).formatPhoneNumber()
        } else if length < 10 || (length == 10 && numbersOnly.hasPrefix("1")) {
            return numbersOnly
        }
        
        var sourceIndex = 0
        
        // Area code
        var areaCode = ""
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return numbersOnly
        }
        areaCode = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return numbersOnly
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return numbersOnly
        }
        
        return areaCode + prefix + "-" + suffix
    }
}


extension String {
    func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
