//
//  RequestAppointmentButton.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/21/23.
//

import SwiftUI

struct RequestAppointmentButton: View {
    @ObservedObject var user = User.shared
    @State var showingRequestAppt = false
    @State var showingMessageUI = false
    
    var body: some View {
//        if User.shared.isLoggedIn {
            RoundedButton(title: "Request Appointment") {
                showingRequestAppt = true
            }
            .padding([.bottom, .leading, .trailing], 20)
            .sheet(isPresented: $showingRequestAppt) {
                RequestUpdateApptView(selectedPackage: MockDetailPackages.basic) { _ in
                    showingRequestAppt = false
                }
            }
//        } else {
//            HStack {
//                RoundedButton(title: "Call", type: .secondary) {
//                    CallHelper.call("3134028121")
//                }
//                RoundedButton(title: "Text", type: .secondary) {
//                    showingMessageUI = true
//                }
//            }
//            .padding(.bottom)
//            .sheet(isPresented: $showingMessageUI) {
//                MessageUIView(recipient: "3134028121") { _ in }
//            }
//        }
    }
}

struct RequestAppointmentButton_Previews: PreviewProvider {
    static var previews: some View {
        RequestAppointmentButton()
    }
}
