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
            Color.black.opacity(0.9)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onTapGesture {
                    viewModel.completion()
                }
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
                                Text(viewModel.appt.statusString).foregroundColor(viewModel.appt.statusStringColor)
                                Text("- \(viewModel.appt.timeOfDay!)")
                            }
                            Text(viewModel.appt.package?.nameAndPriceString ?? "")
                                .font(.title)
                            Text(viewModel.appt.location ?? "")
                            Text(viewModel.appt.carDescription ?? "")
                        }
                    }
                    
                    Spacer()
                    
                    if User.shared.isAdmin {
                        Button("Edit") {
                            viewModel.isEditing = true
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name:").foregroundColor(.gray)
                        Text(viewModel.appt.name!)
                    }
                    HStack {
                        Text("Phone:").foregroundColor(.gray)
                        Text(viewModel.appt.phone!)
                    }
                    .padding(.bottom, 20)
                    
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
            .padding()
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
        
    }
}

struct AppointmentStatusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCellDetailView(appt: Appointment.mockApptRequested) {}
    }
}
