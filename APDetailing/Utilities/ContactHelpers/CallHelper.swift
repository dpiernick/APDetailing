//
//  CallHelper.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/14/23.
//

import Foundation
import UIKit

struct CallHelper {
    
    static func call(_ phoneNumber: String?) {
        if let phoneNumber = phoneNumber?.components(separatedBy: .whitespaces).joined(),
           let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    static var primaryPhone = (UserDefaults.standard.string(forKey: "primaryPhone") ?? "3137017077").formatPhoneNumber()
}
