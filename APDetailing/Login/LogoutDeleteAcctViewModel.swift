//
//  LogoutDeleteAcctViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/27/23.
//

import Foundation
import Firebase

@MainActor class LogoutDeleteAcctViewModel: ObservableObject {
    @Published var showConfirmDeleteAcctAndAppts = false
    var completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func deleteAccountAndAppointments() async -> NetworkingError? {
        let success = await Networking.deleteAllAppointments()
        logOut()
        return success
    }
    
    func logOut() {
        User.shared.logOut()
        completion()
    }
}
