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
        let basicServices: BasicServices? = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("BasicDetailPackageServices").document("BasicServices").getDocument { doc, error in
                guard error == nil, let basic = BasicServices.decode(dictionary: doc?.data() ?? [:]) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: basic)
            }
        })
        
        let detailPackages: [DetailPackage]? = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("DetailPackages").getDocuments { snapshot, error in
                guard error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                
                var packages = [DetailPackage]()
                for doc in snapshot?.documents ?? [] {
                    guard let package = DetailPackage.decode(dictionary: doc.data()) else { return }
                    packages.append(package)
                }
                
                continuation.resume(returning: packages)
            }
        })
        
        DetailMenu.shared.menu = DetailMenuObject(detailPackages: detailPackages, basicServices: basicServices)
        DetailMenu.shared.showingLaunchScreen = false
    }
}
