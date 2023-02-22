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
    case success, failure, decline
}

extension LoginView {
    @MainActor class ViewModel: ObservableObject {
        @Published var phone: String = ""
        @Published var code: String = ""
        @Published var phoneSubmitted = false
        @Published var badPhoneNumber = false
        @Published var loginError = false
        
        func submitPhoneNumber() async {
            let submitted = await Networking.submitPhoneNumber(phone)
            phoneSubmitted = submitted
            badPhoneNumber = !submitted
        }
        
        func signIn() async {
            let success = await Networking.signIn(withCode: code)
            loginError = success
        }
    }
}
