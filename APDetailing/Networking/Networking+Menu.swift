//
//  Networking+Menu.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/22/23.
//

import Foundation
import Firebase

extension Networking {
    static func fetchMenu() async {
        DetailMenu.shared.showingLaunchScreen = true
        async let basicServicesDoc = try? await Firestore.firestore().collection("BasicDetailPackageServices").document("BasicServices").getDocument()
        async let detailPackageDocs = try? await Firestore.firestore().collection("DetailPackages").getDocuments()
        async let addOnDoc = try? await Firestore.firestore().collection("AddOns").getDocuments()
        
        let basicServices = BasicServices.decode(dictionary: await basicServicesDoc?.data() ?? [:])
        
        var detailPackages = [DetailPackage]()
        for doc in await detailPackageDocs?.documents ?? [] {
            if let package = DetailPackage.decode(dictionary: doc.data()) {
                detailPackages.append(package)
            }
        }
        
        var addOns = [AddOn]()
        for doc in await addOnDoc?.documents ?? [] {
            if let addOn = AddOn.decode(dictionary: doc.data()) {
                addOns.append(addOn)
            }
        }
                        
        DetailMenu.shared.menu = DetailMenuObject(detailPackages: detailPackages, basicServices: basicServices, addOns: addOns)
        DetailMenu.shared.showingLaunchScreen = false
    }
}
