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
    @StateObject var viewModel: AppointmentsViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: AppointmentsViewModel())
    }
    
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
                    VStack(spacing: 0) {
                        Picker("Status", selection: $viewModel.statusFilter) {
                            Text("Requested").tag(AppointmentStatus.requested)
                            Text("Completed").tag(AppointmentStatus.completed)
                        }
                        .pickerStyle(.segmented)
                        .padding([.top, .leading, .trailing])
                        
                        if let appts = viewModel.filteredAppts, !appts.isEmpty {
                            List {
                                if viewModel.upcomingAppts.count > 0 {
                                    Section("Upcoming") {
                                        ForEach(viewModel.upcomingAppts) { appt in
                                            AppointmentCellView(appt: appt)
                                                .onTapGesture {
                                                    viewModel.showApptDetail = appt
                                                }
                                                .listRowSeparator(.hidden)
                                        }
                                    }
                                }
                                
                                if viewModel.pastAppts.count > 0 {
                                    Section("Past") {
                                        ForEach(viewModel.pastAppts) { appt in
                                            AppointmentCellView(appt: appt)
                                                .onTapGesture {
                                                    viewModel.showApptDetail = appt
                                                }
                                                .listRowSeparator(.hidden)
                                        }
                                    }
                                }
                            }
                            .listStyle(.plain)
                        } else {
                            Spacer()
                            Text("No Appointments!").frame(alignment: .center)
                            Spacer()
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        RoundedButton(title: "Request Appointment") {
                            viewModel.showingRequestAppt = true
                        }
                        .padding(20)
                        .sheet(isPresented: $viewModel.showingRequestAppt) {
                            RequestUpdateApptView(selectedPackage: DetailMenu.shared.menu.detailPackages?.first) { _ in
                                viewModel.showingRequestAppt = false
                            }
                        }
                        .background(Color.black)
                    }
                    
                    if viewModel.showApptDetail != nil {
                        AppointmentCellDetailView(appt: viewModel.showApptDetail ?? Appointment()) {
                            viewModel.showApptDetail = nil
                        }
                    }
                }
            }
        }
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView()
    }
}
