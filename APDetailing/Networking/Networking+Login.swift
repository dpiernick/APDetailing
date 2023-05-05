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
            return false
        }
        
        shared.isShowingLoadingIndicator = true
        var verificationID: String?
        do {
            verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        } catch {
            print(error)
        }
        self.shared.isShowingLoadingIndicator = false
        
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        return verificationID != nil
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
            
            let success = await fetchAppointments() == nil
            shared.isShowingLoadingIndicator = false
            return success
        } else {
            shared.isShowingLoadingIndicator = false
            return false
        }
    }

    static func deleteUser() async -> NetworkingError? {
        return try? await Auth.auth().currentUser?.delete() == nil ? nil : .error
    }
}
