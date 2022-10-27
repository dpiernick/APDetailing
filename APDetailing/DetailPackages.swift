//
//  DetailPackages.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation

struct DetailPackage: Identifiable, Hashable {
    var id: String
    var price: Int
    var exteriorServices: [ExteriorServices]
    var interiorServices: [InteriorServices]
    
    static func packageForId(_ id: String) -> DetailPackage? {
        return MockDetailPackages.allPackages.filter( { $0.id == id}).first
    }
    
    var priceString: String {
        return "$" + self.price.description
    }
}

enum ExteriorServices: String {
    case foamCannon = "Foam Cannon Wash"
    case waxClearcoat = "Complete Wax & Clear Coat Sealant"
    case wheels = "Wheels Polished"
    case tires = "Tires Shined"
    case engine = "Engine Detailed"
    case undercarriage = "Undercarriage Steam Cleaned"
    case scuffMarks = "All Paint Scuff Marks Removed"
    case wheelWells = "Wheel Wells Cleaned & Shined"
    case wheelsDeep = "Deep Wheel Cleaning"
    case clayBar = "Complete Clay Bar"
}

enum InteriorServices: String {
    case glass = "Glass Cleaned"
    case doorJambs = "Door Jambs, Panels & Dash Wiped"
    case vacuum = "Deep Vacuum"
    case leather = "Leather Conditioned"
    case leatherTrim = "Leather & Trim Conditioned"
    case basicShampoo = "Carpets & Seats Shampoo'd"
    case premiumShampoo = "Carpets, Seats, Door Panels, Headliner & Trunk Shampoo'd"
    
}

struct MockDetailPackages {
    
    static var allPackages = [basic, deluxe, platinum, full, extreme, exclusive]
    
    static var loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    static var basicExterior: [ExteriorServices] = [.foamCannon, .waxClearcoat, .wheels, .tires]
    static var basicInterior: [InteriorServices] = [.glass, .doorJambs, .vacuum]
    static var basic = DetailPackage(id: "IN & OUT", price: 60, exteriorServices: basicExterior, interiorServices: basicInterior)

    static var deluxeExterior: [ExteriorServices] = basicExterior + [.engine]
    static var deluxeInterior: [InteriorServices] = basicInterior + [.leather]
    static var deluxe = DetailPackage(id: "DELUXE", price: 90, exteriorServices: deluxeExterior, interiorServices: deluxeInterior)
    
    static var platinumExterior: [ExteriorServices] = basicExterior + [.engine, .undercarriage]
    static var platinumInterior: [InteriorServices] = basicInterior + [.leather]
    static var platinum = DetailPackage(id: "PLATINUM", price: 125, exteriorServices: platinumExterior, interiorServices: platinumInterior)
    
    static var fullExterior: [ExteriorServices] = basicExterior + [.engine, .undercarriage]
    static var fullInterior: [InteriorServices] = basicInterior + [.leather, .basicShampoo]
    static var full = DetailPackage(id: "FULL", price: 190, exteriorServices: fullExterior, interiorServices: fullInterior)
    
    static var extremeExterior: [ExteriorServices] = basicExterior + [.engine, .undercarriage, .scuffMarks, .wheelWells, .wheelsDeep]
    static var extremeInterior: [InteriorServices] = basicInterior + [.leatherTrim, .premiumShampoo]
    static var extreme = DetailPackage(id: "EXTREME", price: 290, exteriorServices: extremeExterior, interiorServices: extremeInterior)
    
    static var exclusiveExterior: [ExteriorServices] = basicExterior + [.engine, .undercarriage, .scuffMarks, .wheelWells, .wheelsDeep, .clayBar]
    static var exclusiveInterior: [InteriorServices] = basicInterior + [.leatherTrim, .premiumShampoo]
    static var exclusive = DetailPackage(id: "EXCLUSIVE", price: 390, exteriorServices: extremeExterior, interiorServices: extremeInterior)
}
