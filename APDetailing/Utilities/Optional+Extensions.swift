//
//  Optional+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 9/10/23.
//

import Foundation

extension Optional {
    func isNil() -> Bool {
        self == nil
    }
    
    func isNotNil() -> Bool {
        self != nil
    }
}
