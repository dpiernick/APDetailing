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
    
    init(appt: Appointment = Appointment(), selectedPackage: DetailPackage = .fullDetailPackage, menu: DetailMenuObject? = nil, isEditing: Bool = false, _ completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
        _viewModel = StateObject(wrappedValue: RequestUpdateApptViewModel(appt: appt, selectedPackage: selectedPackage, menu: menu, isEditing: isEditing, completion: completion))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        VStack {
                            
                            TextField("Name", text: $viewModel.name)
                                .textFieldStyle(.customTextFieldStyle)
                                .padding(.bottom, 4)
                            
                            TextField("Phone", text: $viewModel.phone)
                                .textFieldStyle(.customTextFieldStyle)
                                .keyboardType(.numberPad)
                                .textContentType(.telephoneNumber)
                                .padding(.bottom, 4)
                                .onChange(of: viewModel.phone) { _ in
                                    viewModel.phone = viewModel.phone.formatPhoneNumber()
                                }
                            
                            DetailPackagePicker(menu: viewModel.menu, selectedPackage: $viewModel.package)
                                .padding(.bottom, 4)
                            
                            TextField("Car Description", text: $viewModel.carDescription, axis: .vertical)
                                .textFieldStyle(.customLongFormTextFieldStyle)
                                .padding(.bottom, 4)
                            
                            LocationSuggestionTextField(viewModel: viewModel, isFocused: isLocationFocused)

                            DatePicker("Appointment Date",
                                       selection: $viewModel.date,
                                       in: Date.now.addingTimeInterval(.day)...Date.now.addingTimeInterval(.week * 8),
                                       displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .accentColor(.red)
                            .onSubmit {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                            
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
                .alert("Something went wrong!", isPresented: $viewModel.isShowingError) {}
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
