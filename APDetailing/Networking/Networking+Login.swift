//
//  Networking+Login.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/19/23.
//

import Foundation
import Firebase
import FirebaseMessaging

enum LoginError: Error {
    case badNumber
    case verifyFailure
    case signInError
}

extension Networking {
    
    //todo specify error
    static func submitPhoneNumber(_ phone: String) async -> LoginError? {
        let phoneNumber = "+1" + phone.numbersOnly
        guard phoneNumber.count == 12 else {
            return .badNumber
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
        return verificationID != nil ? nil : .verifyFailure
    }
    
    static func signIn(withCode code: String) async -> Error? {
        guard let id = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return LoginError.verifyFailure
        }
        
        shared.isShowingLoadingIndicator = true
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        let phoneNumber = try? (await Auth.auth().signIn(with: credential)).user.phoneNumber
        
        if let phoneNumber = phoneNumber {
            await User.shared.setIsLoggedIn(phoneNumber: phoneNumber)            
            shared.isShowingLoadingIndicator = false
            return await fetchAppointments()
        } else {
            print("no phone number error")
            shared.isShowingLoadingIndicator = false
            return LoginError.signInError
        }
    }

    static func deleteUser() async -> NetworkingError? {
        return try? await Auth.auth().currentUser?.delete() == nil ? nil : .error
    }
}
