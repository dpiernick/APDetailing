//
//  AppointmentsViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/27/23.
//

import Foundation
import SwiftUI

@MainActor class AppointmentsViewModel: ObservableObject {
    @Published var selectedPackage: DetailPackage? = nil
    @Published var showingRequestAppt = false
    @Published var showingMessageUI = false
    @Published var showApptDetail: Appointment? = nil
    @Published var statusFilter: AppointmentStatus = .requested
    
    var filteredAppts: [Appointment]? {
        guard let appts = User.shared.appointments else { return nil }
        
        if statusFilter == .requested {
            return appts.filter({ $0.status == .requested || $0.status == .confirmed })
        } else {
            return appts.filter({ $0.status == .completed || $0.status == .cancelled })
        }
    }
    
    var upcomingAppts: [Appointment] {
        guard let appts = filteredAppts else { return [] }
        return appts.filter({ $0.date ?? Date() > Date() })
    }
    
    var pastAppts: [Appointment] {
        guard let appts = filteredAppts else { return [] }
        return appts.filter({ $0.date ?? Date() <= Date() })
    }
}
