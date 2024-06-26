//
//  User.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseMessaging

struct Admin: Codable {
    var phone: String?
}

@MainActor class User: ObservableObject {
    @Published var userID: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var appointments: [Appointment]? = nil
    
    static let shared = User()

    private init() {}
    
    func login() {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            Task {
                await setIsLoggedIn(phoneNumber: userID)
                let success = await Networking.fetchAppointments() == nil
                if success == false { logOut() }
            }
        }
    }
    
    var isAdmin: Bool {
        return userID != nil ? UserDefaults.standard.stringArray(forKey: "adminIDs")?.contains(userID!) == true : false
    }
    
    func setIsLoggedIn(phoneNumber: String) async {
        self.isLoggedIn = true
        self.userID = phoneNumber
        UserDefaults.standard.set(phoneNumber, forKey: "userID")
        
        //Store FCMToken for Appt Update Notifications
        if let fcmToken = try? await Messaging.messaging().token() {
            try? await Firestore.firestore().collection("Users").document(phoneNumber).setData(["fcmToken": fcmToken])
        }

        //Subscribe admins to New Appt Notifications
        if User.shared.isAdmin {
            try? await Messaging.messaging().subscribe(toTopic: "admin")
        }
    }
    
    func setAppointments(_ appts: [Appointment]) async {
        self.appointments = appts
    }
    
    func logOut() {
        appointments = nil
        userID = nil
        UserDefaults.standard.set(nil, forKey: "userID")
        isLoggedIn = false
    }
}


