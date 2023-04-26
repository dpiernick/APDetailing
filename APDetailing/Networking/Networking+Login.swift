//
//  Networking+Login.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/19/23.
//

import Foundation
import Firebase
import FirebaseMessaging

extension Networking {
    
    //todo specify error
    static func submitPhoneNumber(_ phone: String) async -> Bool {
        let phoneNumber = "+1" + phone.numbersOnly
        guard phoneNumber.count == 12 else {
            self.shared.isShowingLoadingIndicator = false
            return false
        }
        
        shared.isShowingLoadingIndicator = true
        guard let verificationID = try? await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) else {
            self.shared.isShowingLoadingIndicator = false
            return false
        }
                
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        self.shared.isShowingLoadingIndicator = false
        return true
    }
    
    static func signIn(withCode code: String) async -> Bool {
        guard let id = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return false
        }
        
        shared.isShowingLoadingIndicator = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        let phoneNumber = try? (await Auth.auth().signIn(with: credential)).user.phoneNumber
        
        if let phoneNumber = phoneNumber {
            await User.shared.setIsLoggedIn(phoneNumber: phoneNumber)
            
            if User.shared.isAdmin {
                try? await Messaging.messaging().subscribe(toTopic: "admin")
            }
            
            let success = await fetchAppointments() == nil
            shared.isShowingLoadingIndicator = false
            return success
        } else {
            shared.isShowingLoadingIndicator = false
            return false
        }
    }

}
