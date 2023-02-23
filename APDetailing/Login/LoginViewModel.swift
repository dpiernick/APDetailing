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
    @Published var loginError = false
    
    var completion: ((LoginResult) -> Void)?
    
    init(phone: String? = nil, completion: ((LoginResult) -> Void)?) {
        self.phone = phone ?? ""
        self.completion = completion
    }
    
    func submitPhoneNumber() async {
        let submitted = await Networking.submitPhoneNumber(phone)
        phoneSubmitted = submitted
        badPhoneNumber = !submitted
    }
    
    func signIn() async {
        if await Networking.signIn(withCode: code) {
            completion?(.success)
        } else {
            loginError = true
        }
    }
}
