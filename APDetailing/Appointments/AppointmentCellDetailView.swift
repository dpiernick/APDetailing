//
//  AppointmentCellDetailView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/13/23.
//

import SwiftUI

struct AppointmentCellDetailView: View {
    @StateObject var viewModel: AppointmentCellDetailViewModel
    
    init(appt: Appointment, completion: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: AppointmentCellDetailViewModel(appt: appt, completion: completion))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onTapGesture {
                    viewModel.completion()
                }
            
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "xmark")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        
                        if let date = viewModel.appt.date {
                            VStack {
                                Text(date.monthAbbv)
                                Text(date.dayOfMonth).font(.title)
                                Text(date.year)
                            }
                            .padding(.trailing)
                        }
                        
                        VStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(viewModel.appt.status?.rawValue ?? "").foregroundColor(viewModel.appt.statusStringColor)
                                    Text("- \(viewModel.appt.timeString ?? "Time: ???")")
                                }
                                Text(viewModel.appt.package?.nameAndPriceString ?? "")
                                    .font(.title)
                                Text(viewModel.appt.location ?? "")
                            }
                        }
                        
                        Spacer()
                        
                        
                        if User.shared.isAdmin == true{
                            Button("Edit") {
                                viewModel.isEditing = true
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        if let addOns = viewModel.appt.addOns,
                           addOns.isEmpty == false,
                           let addOnsPrice = viewModel.appt.addOnsPrice {
                            HStack(alignment: .top) {
                                Text("Add Ons:").foregroundColor(.gray)
                                Text(addOns.compactMap({ $0.name }).joined(separator: ", "))
                            }
                            
                            HStack(alignment: .top) {
                                Text("Add Ons Price:").foregroundColor(.gray)
                                Text("$\(addOnsPrice)")
                            }
                        }
                        
                        if let car = viewModel.appt.carDescription {
                            HStack(alignment: .top) {
                                Text("Car:").foregroundColor(.gray)
                                Text(car)
                            }
                        }
                    }
                    
                    if let totalPrice = viewModel.appt.totalApptPrice {
                        HStack {
                            Text("Total:").foregroundColor(.gray)
                            Text("$\(totalPrice)")
                        }
                        .font(.title2)
                    }
                     
                    VStack(alignment: .leading) {
                        if let name = viewModel.appt.name {
                            HStack(alignment: .top) {
                                Text("Name:").foregroundColor(.gray)
                                Text(name)
                            }
                        }
                        
                        if let phone = viewModel.appt.phone {
                            HStack(alignment: .top) {
                                Text("Phone:").foregroundColor(.gray)
                                Text(phone)
                            }
                        }
                    }
                        
                    VStack(spacing: 10) {
                        if User.shared.isAdmin == false {
                            Text("Contact AP Detailing")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        HStack {
                            RoundedButton(title: "Call", type: .secondary) { viewModel.call() }
                            RoundedButton(title: "Text", type: .secondary) { viewModel.showingMessageUI = true }
                                .sheet(isPresented: $viewModel.showingMessageUI) {
                                    MessageUIView(recipient: viewModel.getPhoneNumberToText() ?? "")
                                }
                        }
                    }

                    
                    if User.shared.isAdmin {
                        VStack(spacing: 20) {
                            RoundedButton(title: "Confirm", color: .green) {
                                Task { await viewModel.updateStatusToConfirmed() }
                            }
                            HStack(spacing: 16) {
                                RoundedButton(title: "Completed", color: .green) {
                                    viewModel.showingConfirmCompleted = true
                                }
                                .alert(isPresented: $viewModel.showingConfirmCompleted) {
                                    Alert(title: Text("Are you sure you want to mark this appointment as \"Completed\"?"),
                                          primaryButton: .default(
                                            Text("Yes"),
                                            action: {
                                                Task { await viewModel.updateStatusToCompleted() }
                                            }),
                                          secondaryButton: .default(Text("Nevermind")))
                                }
                                
                                RoundedButton(title: "Deny") {
                                    viewModel.showingConfirmCancel = true
                                }
                                .alert(isPresented: $viewModel.showingConfirmCancel) {
                                    Alert(title: Text("Are you sure you want to deny/cancel this appointment?"),
                                          primaryButton: .default(Text("Nevermind")),
                                          secondaryButton: .destructive(
                                            Text("Deny/Cancel"),
                                            action: {
                                                Task { await viewModel.updateStatusToCancelled() }
                                            }))
                                }
                            }
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.red, lineWidth: 1)
                        .background {
                            Color.black
                        }
                }
                .sheet(isPresented: $viewModel.isEditing) {
                    RequestUpdateApptView(appt: viewModel.appt, menu: DetailMenu.shared.menu, isEditing: true) { result in
                        viewModel.isEditing = false
                        if let newAppt = try? result.get() {
                            self.viewModel.appt = newAppt
                        }
                    }
                }
                .alert("Something went wrong", isPresented: $viewModel.showingError) {}
            }
            .padding()
        }
    }
}

struct AppointmentStatusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCellDetailView(appt: Appointment.mockApptRequested) {}
    }
}
