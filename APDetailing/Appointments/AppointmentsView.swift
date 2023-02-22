//
//  MyAppointmentsView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import SwiftUI
import Firebase

struct AppointmentsView: View {
    @ObservedObject var user = User.shared
    @State var selectedPackage: DetailPackage = MockDetailPackages.basic
    @State var showingRequestAppt = false
    @State var showingMessageUI = false
    @State var showApptDetail: Appointment? = nil
    
    var body: some View {
        ContainerView() {
            if user.isLoggedIn == false {
                VStack {
                    Spacer()
                    LoginView()
                    Spacer()
                }
            } else {
                ZStack {
                    VStack {
                        if let appts = user.appointments, !appts.isEmpty {
                            List(appts) { appt in
                                AppointmentCellView(appt: appt)
                                    .onTapGesture {
                                        showApptDetail = appt
                                    }
                                    .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            Spacer()
                        } else {
                            Spacer()
                            Text("No Appointments!").frame(alignment: .center)
                            Spacer()
                        }
                    }
                    
                    if showApptDetail != nil {
                        AppointmentCellDetailView(appt: showApptDetail!) {
                            showApptDetail = nil
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            RequestAppointmentButton()
        }

    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView()
    }
}
