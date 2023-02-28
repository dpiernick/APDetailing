//
//  DetailPackages.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation

struct DetailMenuObject: Codable {
    var detailPackages: [DetailPackage]?
    var aLaCarte: [ALaCarteItem]?
    var basicServices: BasicServices?
}

struct DetailPackage: Codable, Hashable, Identifiable {
    var id: Int?
    var name: String?
    var price: Int?
    var exteriorServices: [String]?
    var interiorServices: [String]?
    
    var nameAndPriceString: String? {
        guard let name = name, let price = price else { return nil }
        return "\(name) - $\(price)"
    }
    
    static let defaultPriceStrings = ["In & Out - $60",
                       "Deluxe - $90",
                       "Platinum - $125",
                       "Full - $190",
                       "Extreme - $290",
                       "Exclusive - $390"]
    
    static let inOutDetailPackage = DetailPackage(id: 1,
                                                 name: "In & Out",
                                                 price: 60,
                                                 exteriorServices: ["Foam Cannon Wash", "Complete Wax & Clear Coat Sealant", "Wheels Polished", "Tires Shined"],
                                                 interiorServices: ["Glass Cleaned", "Door Jambs, Panels & Dash Wiped", "Deep Vacuum"])
    
    static let fullDetailPackage = DetailPackage(id: 3,
                                                 name: "Full Detail",
                                                 price: 190,
                                                 exteriorServices: ["Foam Cannon Wash", "Complete Wax & Clear Coat Sealant", "Wheels Polished", "Tires Shined", "Engine Detailed", "Undercarriage Steam Cleaned"],
                                                 interiorServices: ["Glass Cleaned", "Door Jambs, Panels & Dash Wiped", "Deep Vacuum", "Leather Conditioned", "Carpets & Seats Shampoo'd"])
}

struct BasicServices: Codable {
    var exteriorServices: [String]?
    var interiorServices: [String]?
}

struct ALaCarteItem: Codable {
    var name: String?
    var price: Int?
}