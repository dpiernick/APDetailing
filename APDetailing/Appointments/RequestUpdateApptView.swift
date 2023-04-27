//
//  RequestDateView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation
import SwiftUI
import MessageUI

enum TimeOfDay: String {
    case morning = "Morning"
    case afternoon = "Afternoon"
}

struct RequestUpdateApptView: View {
    @StateObject var user = User.shared
    @StateObject var viewModel: RequestUpdateApptViewModel
    @State var isLocationFocused: Bool = false
    var spacing: CGFloat = 10
    
    init(appt: Appointment? = nil, selectedPackage: DetailPackage = .fullDetailPackage, menu: DetailMenuObject? = nil, isEditing: Bool = false, _ completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
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

                            CustomLongFormTextField("Car Description", text: $viewModel.carDescription)
                            
                            DetailPackagePicker(menu: viewModel.menu, selectedPackage: $viewModel.package)
                                                        
                            AddOnChecklist(selectedAddOns: $viewModel.addOns)
                            
                            if let totalPrice = viewModel.appt.totalApptPrice,
                               totalPrice > 0 {
                                HStack {
                                    Spacer()
                                    Text("Total: $\(totalPrice)")
                                        .padding(spacing)
                                        .font(.title)
                                        .bold()
                                }
                            }
                            
                            DatePicker("Appointment Date",
                                       selection: $viewModel.date,
                                       in: Date.now.addingTimeInterval(.day)...Date.now.addingTimeInterval(.week * 8),
                                       displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .accentColor(.red)
                            .onChange(of: viewModel.date, perform: { _ in
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            })
                            
                            HStack {
                                RoundedButton(title: "Morning", type: viewModel.timeOfDay == .morning ? .primary : .secondary) {
                                    viewModel.timeOfDay = .morning
                                }
                                
                                RoundedButton(title: "Afternoon", type: viewModel.timeOfDay == .afternoon ? .primary : .secondary) {
                                    viewModel.timeOfDay = .afternoon
                                }
                            }
                        }
                        .padding([.top, .leading, .trailing])
                        
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
                .alert("Please fill in all required information", isPresented: $viewModel.invalidAppointment) {}
                .alert("Something went wrong requesting your appointment, please try again.", isPresented: $viewModel.isShowingSubmitError) {}
                .alert("Something went wrong updating your appointment, please try again.", isPresented: $viewModel.isShowingUpdateError) {}
                .alert("Your appointment was submitted, but something went wrong updating the list", isPresented: $viewModel.isShowingSubmitError) {}
                .alert("Invalid Address", isPresented: $viewModel.isShowingLocationError) {}
                .alert(isPresented: $viewModel.distanceTooFar) {
                    Alert(title: Text("We don't service this area"),
                          message: Text("Currently only serving Detroit, MI and surrounding areas."),
                          dismissButton: .cancel( { isLocationFocused = true } ))
                    }
                
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
