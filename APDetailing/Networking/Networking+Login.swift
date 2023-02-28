//
//  Networking+Login.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/19/23.
//

import Foundation
import Firebase

extension Networking {
    
    static func submitPhoneNumber(_ phone: String) async -> Bool {
        await withCheckedContinuation({ continuation in
            let phoneNumber = "+1" + phone.numbersOnly
            guard phoneNumber.count == 12 else {
                continuation.resume(returning: false)
                return
            }
            
            shared.isShowingLoadingIndicator = true
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    continuation.resume(returning: false)
                    self.shared.isShowingLoadingIndicator = false
                    return
                }
                
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                continuation.resume(returning: true)
                self.shared.isShowingLoadingIndicator = false
            }
        })
    }
    
    static func signIn(withCode code: String) async -> Bool {
        guard let id = UserDefaults.standard.string(forKey: "authVerificationID") else {
            return false
        }
        
        shared.isShowingLoadingIndicator = true
        let phoneNumber: String? = await withCheckedContinuation({ continuation in
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
            Auth.auth().signIn(with: credential) { result, error in
                continuation.resume(returning: result?.user.phoneNumber)
            }
        })
        
        await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Admin").document("Admin").getDocument { document, error in
                let adminIDsObject = Admin.decode(dictionary: document?.data() ?? [:])
                UserDefaults.standard.set(adminIDsObject?.primaryPhone, forKey: "primaryPhone")
                UserDefaults.standard.set(adminIDsObject?.adminIDs, forKey: "adminIDs")
                continuation.resume()
            }
        })
        
        if let phoneNumber = phoneNumber {
            await User.shared.setIsLoggedIn(phoneNumber: phoneNumber)
            let success: Bool = await fetchAppointments()
            shared.isShowingLoadingIndicator = false
            return success
        } else {
            shared.isShowingLoadingIndicator = false
            return false
        }
    }
}
