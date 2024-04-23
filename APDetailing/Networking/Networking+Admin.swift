//
//  Networking+Admin.swift
//  APDetailing
//
//  Created by Dave Piernick on 4/24/23.
//

import Foundation
import Firebase
import FirebaseMessaging

extension Networking {
    static func getAdminInfo() async {
        async let _ = getPrimaryPhoneNumber()
        async let _ = getAdmins()
    }
    
    private static func getPrimaryPhoneNumber() async {
        guard let doc = try? await Firestore.firestore().collection("PrimaryPhone").document("PrimaryPhoneNumber").getDocument() else { return }
        let primaryPhone = doc.data()?["primaryPhoneNumber"] ?? "+13137017077"
        UserDefaults.standard.set(primaryPhone, forKey: "primaryPhone")
    }
    
    private static func getAdmins() async {
        guard let snapshot = try? await Firestore.firestore().collection("Admin").getDocuments() else { return }
        var adminIds = [String]()
        for doc in snapshot.documents {
            if let adminObject = Admin.decode(dictionary: doc.data()), let phone = adminObject.phone {
                adminIds.append(phone)
            }
        }
        UserDefaults.standard.set(adminIds, forKey: "adminIDs")
    }
}
