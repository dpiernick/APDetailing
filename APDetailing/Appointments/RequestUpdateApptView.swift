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
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel
    
    init(appt: Appointment, _ completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
        _viewModel = StateObject(wrappedValue: ViewModel(appt: appt, completion: completion))
    }
    
    init(selectedPackage: DetailPackage, _ completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
        _viewModel = StateObject(wrappedValue: ViewModel(selectedPackage: selectedPackage, completion: completion))
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
                            
                            DetailPackagePicker(selectedPackage: $viewModel.package)
                                .padding(.bottom, 4)
                            
                            TextField("Car Description", text: $viewModel.carDescription, axis: .vertical)
                                .textFieldStyle(.customLongFormTextFieldStyle)
                                .padding(.bottom, 4)
                            
                            TextField("Location", text: $viewModel.location)
                                .textFieldStyle(.customTextFieldStyle)
                                .onChange(of: viewModel.location) { newValue in
                                    viewModel.fetchingLocationTask = Task {
                                        await viewModel.getLocationSuggestions(query: newValue)
                                    }
                                }
                        }
                        .padding([.top, .leading, .trailing])
                        
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
                        .padding(.horizontal)
                        
                        if viewModel.isEditing {
                            RoundedButton(title: "Update Appointment", type: .primary) {
                                await viewModel.updateAppointment()
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
                .alert("Please fill in all required information", isPresented: $viewModel.invalidAppointment) {
                    Button("OK", role: .cancel, action: {})
                }
                .alert("Something went wrong!", isPresented: $viewModel.isShowingError) {
                    Button("OK", role: .cancel, action: {})
                }
            }
        }
    }
}

struct RequestApptView_Previews: PreviewProvider {
    static var previews: some View {
        RequestUpdateApptView(selectedPackage: MockDetailPackages.basic) { _ in }
    }
}
