//
//  AppointmentCellDetailViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/27/23.
//

import Foundation

@MainActor class AppointmentCellDetailViewModel: ObservableObject {
    @Published var appt: Appointment
    @Published var showingMessageUI = false
    @Published var showingConfirmCompleted = false
    @Published var showingConfirmCancel = false
    @Published var showingError = false
    @Published var isEditing = false
    
    var completion: () -> Void
    
    init(appt: Appointment, completion: @escaping () -> Void) {
        self.appt = appt
        self.completion = completion
    }
    
    func call() {
        if User.shared.isAdmin {
            CallHelper.call(appt.phone)
        } else {
            CallHelper.call(User.shared.adminIDs.first ?? CallHelper.adamWorkPhone)
        }
    }
    
    func getPhoneNumberToText() -> String? {
        if User.shared.isAdmin {
            return appt.phone
        } else {
            return User.shared.adminIDs.first ?? CallHelper.adamWorkPhone
        }
    }
    
    func updateStatusToConfirmed() async {
        let success = await Networking.updateAppointmentStatus(apptID: appt.id ?? "", status: .confirmed)
        if success { appt.status = .confirmed }
        completion()
    }
    
    func updateStatusToCompleted() async {
        let success = await Networking.updateAppointmentStatus(apptID: appt.id ?? "", status: .completed)
        if success { appt.status = .completed }
        completion()
    }
    
    func updateStatusToCancelled() async {
        let success = await Networking.updateAppointmentStatus(apptID: appt.id ?? "", status: .cancelled)
        if success { appt.status = .cancelled }
        completion()
    }
}
