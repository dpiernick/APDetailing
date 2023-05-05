//
//  LogoutDeleteAcctView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/27/23.
//

import SwiftUI

struct LogoutDeleteAcctView: View {
    @StateObject var viewModel: LogoutDeleteAcctViewModel
    
    init(completion: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: LogoutDeleteAcctViewModel(completion: completion))
    }
    
    var body: some View {
        if let phoneNumber = User.shared.userID {
            VStack(spacing: 20) {
                Text("Logged in as \"\(phoneNumber)\"")
                
                RoundedButton(title: "Log Out") {
                    viewModel.logOut()
                }
                
                RoundedButton(title: "Delete Account & Appointments") {
                    viewModel.showConfirmDeleteAcctAndAppts = true
                }
                .alert(isPresented: $viewModel.showConfirmDeleteAcctAndAppts) {
                    Alert(title: Text("Are you sure you want to delete the account and all appointments associated with \"\(phoneNumber)\""),
                          primaryButton: .default(Text("Nevermind")),
                          secondaryButton: .destructive(
                            Text("Delete"),
                            action: {
                                Task { await viewModel.deleteAccountAndAppointments() }
                            }))
                }
                .alert("Admins can't delete all the appointments. Call Dave", isPresented: $viewModel.isShowingAdminDeleteError, actions: {})
                .alert("Something went wrong", isPresented: $viewModel.isShowingNetworkingError, actions: {})
            }
            .padding()
        }
    }
}

struct LogoutDeleteAcctView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutDeleteAcctView() {}
    }
}
