//
//  AppointmentCellDetailView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/13/23.
//

import SwiftUI

struct AppointmentCellDetailView: View {
    @State var appt: Appointment
    @State var showingMessageUI = false
    @State var showingConfirmCancel = false
    @State var showingError = false
    @State var isEditing = false
    
    var completion: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .onTapGesture {
                    completion()
                }
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack {
                        Text(appt.date!.monthAbbv)
                        Text(appt.date!.dayOfMonth).font(.title)
                        Text(appt.date!.year)
                    }
                    .padding(.trailing)
                    
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(appt.statusString).foregroundColor(appt.statusStringColor)
                                Text("- \(appt.timeOfDay!)")
                            }
                            Text("\(appt.package!.id) - $\(appt.package!.price)")
                                .font(.title)
                            Text(appt.location!)
                            Text(appt.carDescription!)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Edit") {
                        isEditing = true
                    }
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name:").foregroundColor(.gray)
                            Text(appt.name!)
                        }
                        HStack {
                            Text("Phone:").foregroundColor(.gray)
                            Text(appt.phone!)
                        }
                    }
                    HStack {
                        RoundedButton(title: "Call", type: .secondary) { CallHelper.call(appt.phone) }
                        RoundedButton(title: "Text", type: .secondary) { showingMessageUI = true }
                            .sheet(isPresented: $showingMessageUI) {
                                MessageUIView(recipient: appt.phone)
                            }
                    }
                }
                
                VStack(spacing: 20) {
                    RoundedButton(title: "Confirm", color: .green) {
                        showingError = await Networking.updateAppointmentStatus(apptID: appt.id ?? "", status: .confirmed)
                        completion()
                    }
                    RoundedButton(title: "Deny", type: .hugger) {
                        showingConfirmCancel = true
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
            .sheet(isPresented: $isEditing) {
                RequestUpdateApptView(appt: appt) { result in
                    isEditing = false
                    if let newAppt = try? result.get() {
                        self.appt = newAppt
                    }
                }
            }
            .alert(isPresented: $showingConfirmCancel) {
                Alert(title: Text("Are you sure you want to deny/cancel this appointment?"),
                      primaryButton: .default(
                        Text("Nevermind"),
                        action: {
                    showingConfirmCancel = false
                }),
                      secondaryButton: .destructive(
                        Text("Deny/Cancel"),
                        action: {
                            Task {
                                await Networking.updateAppointmentStatus(apptID: appt.id ?? "", status: .cancelled)
                            }
                        }))
            }
            .alert("Something went wrong", isPresented: $showingError) {}
        }
        
    }
}

struct AppointmentStatusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCellDetailView(appt: MockAppointments.appt1) {}
    }
}
