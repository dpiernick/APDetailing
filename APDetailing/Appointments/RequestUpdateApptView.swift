//
//  RequestDateView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation
import SwiftUI
import MessageUI

struct RequestUpdateApptView: View {
    @StateObject var user = User.shared
    @StateObject var viewModel: RequestUpdateApptViewModel
    @State var isLocationFocused: Bool = false
    var spacing: CGFloat = 10
    
    init(appt: Appointment? = nil, selectedPackage: DetailPackage? = nil, menu: DetailMenuObject? = nil, isEditing: Bool = false, _ completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
        _viewModel = StateObject(wrappedValue: RequestUpdateApptViewModel(appt: appt, selectedPackage: selectedPackage, menu: menu, isEditing: isEditing, completion: completion))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: spacing) {
                                
                                CustomTextField("Name", text: $viewModel.name)
                                
                                CustomTextField("Phone", text: $viewModel.phone)
                                    .keyboardType(.numberPad)
                                    .textContentType(.telephoneNumber)
                                    .onChange(of: viewModel.phone) { _ in
                                        viewModel.phone = viewModel.phone.formatPhoneNumber()
                                    }
                                
                                LocationSuggestionTextField(viewModel: viewModel, isFocused: isLocationFocused)

                                CustomTextField("Car Description", text: $viewModel.carDescription, isLongForm: true)
                                
                                DetailPackagePicker(menu: viewModel.menu, selectedPackage: $viewModel.package)
                                                            
                                AddOnChecklist(selectedAddOns: $viewModel.addOns)
                                
                                if let totalPrice = viewModel.appt.totalApptPrice,
                                   totalPrice > 0 {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("Total: $\(totalPrice)*")
                                                .font(.title)
                                                .bold()
                                                .padding(.bottom, 2)
                                        }
                                        
                                        Text("*Note: Pricing may vary based on vehicle condition.")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                            .italic()
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(spacing)
                                }
                                
                                AppointmentDatePicker(date: $viewModel.date)

                            }
                            .padding([.top, .leading, .trailing])
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        ZStack {
                            Color(uiColor: .systemBackground)
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                            
                            if viewModel.isEditing {
                                RoundedButton(title: "Update Appointment", type: .primary) {
                                    Task { await viewModel.updateAppointment() }
                                }
                                .padding()
                            } else {
                                RoundedButton(title: "Request Appointment", type: .primary) {
                                    await viewModel.requestAppointment()
                                }
                                .padding()
                            }
                        }
                        

                    }
                    .preferredColorScheme(.dark)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(viewModel.isEditing ? "Update Appointment" : "Request Appointment").font(Font.system(size: 24).bold())
                        }
                    }

//                .alert("Please fill in all required information", isPresented: $viewModel.invalidAppointment) {}
//                .alert("Something went wrong requesting your appointment, please try again.", isPresented: $viewModel.isShowingRequestError) {}
//                .alert("Something went wrong updating your appointment, please try again.", isPresented: $viewModel.isShowingUpdateError) {}
//                .alert("Your appointment was requested, but something went wrong updating the list", isPresented: $viewModel.isShowingFetchError) {}
//                .alert("Please enter a valid location", isPresented: $viewModel.isShowingLocationError) {}
//                .alert("Sorry, we currently only serve the Detroit Metro area", isPresented: $viewModel.distanceTooFar) {}
                
                if user.isLoggedIn == false && viewModel.isShowingLogin {
                    LoginView(phone: viewModel.phone) { result in
                        Task { await viewModel.handleLogin(result: result) }
                    }
                }
            }
        }
    }
}

struct RequestApptView_Previews: PreviewProvider {
    static var previews: some View {
        RequestUpdateApptView() { _ in }
    }
}
