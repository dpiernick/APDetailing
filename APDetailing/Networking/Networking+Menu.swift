//
//  Networking+Menu.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/22/23.
//

import Foundation
import Firebase

extension Networking {
    static func fetchMenu() async -> DetailMenuObject? {        

        async let services = fetchServices()
        async let packages = fetchPackages()
        async let addOns = fetchAddOns()
        
        if let packages = await packages, let basicServices = await services, let addOns = await addOns {
            return DetailMenuObject(detailPackages: packages, basicServices: basicServices, addOns: addOns)
        } else {
            return nil
        }
    }
    
    static func fetchServices() async -> BasicServices? {
        guard let basicServicesDoc = try? await Firestore.firestore().collection("BasicDetailPackageServices")
                                                                     .document("BasicServices").getDocument() else { return nil }
            return BasicServices.decode(dictionary: basicServicesDoc.data() ?? [:])
    }
    
    static func fetchPackages() async -> [DetailPackage]? {
        guard let packageDoc = try? await Firestore.firestore().collection("DetailPackages").getDocuments() else { return nil }
        var detailPackages = [DetailPackage]()
        for doc in packageDoc.documents {
            if let package = DetailPackage.decode(dictionary: doc.data()) {
                detailPackages.append(package)
            }
        }
        return detailPackages
    }
    
    static func fetchAddOns() async -> [AddOn]? {
        guard let addOnDoc = try? await Firestore.firestore().collection("AddOns").getDocuments() else { return nil }
        var addOns = [AddOn]()
        for doc in addOnDoc.documents {
            if let addOn = AddOn.decode(dictionary: doc.data()) {
                addOns.append(addOn)
            }
        }
        return addOns
    }
}
