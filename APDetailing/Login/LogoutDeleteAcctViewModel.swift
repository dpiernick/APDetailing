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
    @Published var isShowingAdminDeleteError = false
    @Published var isShowingNetworkingError = false
    
    var completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    func deleteAccountAndAppointments() async {
        guard User.shared.isAdmin == false else {
            isShowingAdminDeleteError = true
            return
        }

        let deleteApptsSuccess = await Networking.deleteAllAppointments() == nil
        let deleteUserSuccess = await Networking.deleteUser() == nil
        isShowingNetworkingError = !(deleteApptsSuccess && deleteUserSuccess)
    }
    
    func logOut() {
        User.shared.logOut()
        completion()
    }
}
