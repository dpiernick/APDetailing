//
//  LoginViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/15/23.
//

import Foundation
import Firebase
import SwiftUI

enum LoginResult {
    case success, dismiss
}

@MainActor class LoginViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var code: String = ""
    @Published var phoneSubmitted = false
    @Published var badPhoneNumber = false
    @Published var showingLoginError = false
    @Published var loginErrorMessage = "Something went wrong"
    
    var completion: ((LoginResult) -> Void)?
    
    init(phone: String? = nil, completion: ((LoginResult) -> Void)?) {
        self.phone = phone ?? ""
        self.completion = completion
    }
    
    func submitPhoneNumber() async {
        let error = await Networking.submitPhoneNumber(phone)
        switch error {
        case .badNumber:
            badPhoneNumber = true
        case .verifyFailure:
            showingLoginError = true
        default: phoneSubmitted = true
        }
    }
    
    func signIn() async {
        guard let error = await Networking.signIn(withCode: code) else {
            completion?(.success)
            return
        }
        
        switch error {
        case LoginError.verifyFailure:
            loginErrorMessage = "Something went wrong"
        case LoginError.signInError:
            loginErrorMessage = "Could not verify phone number"
        case AppointmentError.fetchError:
            loginErrorMessage = "Logged in but could not fetch appointments"
        default:
            completion?(.success)
        }
    }
}
