//
//  DetailPackages.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation

struct DetailMenuObject: Codable {
    var detailPackages: [DetailPackage]?
    var basicServices: BasicServices?
    var addOns: [AddOn]
}

struct DetailPackage: Codable, Hashable, Identifiable {
    var id: Int?
    var name: String?
    var isSUV: Bool? = false
    var price: Int?
    var price2: Int?
    var exteriorServices: [String]?
    var interiorServices: [String]?
    
    var nameAndPriceString: String? {
        guard let name = name else { return nil }
        if let price = !(isSUV ?? true) ? price : price2 {
            return "\(name) - $\(price)"
        } else {
            return "\(name)"
        }
    }
    
    static let defaultPriceStrings = ["Full - $1225",
                       "Extreme - $390",
                       "Exclusive - $490"]
    
    static let fullDetailPackage = DetailPackage(id: 3,
                                                 name: "Full",
                                                 price: 225,
                                                 price2: 265,
                                                 exteriorServices: ["Foam Cannon Wash", "Complete Wax & Clear Coat Sealant", "Wheels Polished", "Tires Shined", "Engine Detailed", "Undercarriage Steam Cleaned"],
                                                 interiorServices: ["Glass Cleaned", "Door Jambs, Panels & Dash Wiped", "Deep Vacuum", "Leather Conditioned", "Carpets & Seats Shampoo'd"])
    
    static let otherDetailPackage = DetailPackage(id: 4,
                                                 name: "other",
                                                 price: 688,
                                                 price2: 788,
                                                 exteriorServices: ["Foam Cannon Wash", "Complete Wax & Clear Coat Sealant", "Wheels Polished", "Tires Shined", "Engine Detailed", "Undercarriage Steam Cleaned"],
                                                 interiorServices: ["Glass Cleaned", "Door Jambs, Panels & Dash Wiped", "Deep Vacuum", "Leather Conditioned", "Carpets & Seats Shampoo'd"])
}

struct BasicServices: Codable {
    var exteriorServices: [String]?
    var interiorServices: [String]?
}

struct AddOn: Codable, Hashable {
    var name: String?
    var price: Int?
    var type: AddOnType?
    
    var nameAndPriceString: String? {
        if let name = name, let price = price {
            return "\(name) - $\(price)"
        } else if let name = name {
            return "\(name)"
        } else {
            return nil
        }
    }
}

enum AddOnType: String, Codable {
    case exterior
    case interior
}
