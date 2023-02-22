//
//  AppointmentModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation
import SwiftUI

struct Appointment: Codable, Identifiable {
    var id: String? = ""
    var userID: String? = ""
    var name: String? = ""
    var phone: String? = ""
    var date: Date? = Date()
    var timeOfDay: String? = ""
    var location: String? = ""
    var carDescription: String? = ""
    var package: DetailPackage? = MockDetailPackages.basic
    var status: AppointmentStatus? = .requested
    
    var statusString: String {
        switch status {
        case .confirmed: return "Confirmed"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        default: return "Requested"
        }
    }
    
    var statusStringColor: Color {
        switch status {
        case .confirmed: return .green
        case .completed: return .green
        case .cancelled: return .red
        default: return .orange
        }
    }
    
    func validateAppt() -> Bool {
        return (name.isNotNilAndNotEmpty &&
                phone.isNotNilAndNotEmpty &&
                date != nil &&
                timeOfDay != nil &&
                location.isNotNilAndNotEmpty &&
                package != nil &&
                carDescription.isNotNilAndNotEmpty)
    }
    
    func requestMessageBody() -> String {
        guard validateAppt() else { return "" }
        return """
               Hi, I'd like to request an appointment:
               \(date!.formatted(date: .complete, time: .omitted)) - \(timeOfDay ?? "Any Time")
               \(name!) - \(phone!)
               \(location!)
               \(package!.id) - \(package!.priceString)
               \(carDescription!)
               """
    }
}

enum AppointmentStatus: String, Codable {
    case requested
    case confirmed
    case completed
    case cancelled
}

struct MockAppointments {
    static let appt1 = Appointment(id: "1",
                                   name: "name1",
                                   phone: "phone1",
                                   date: Date(),
                                   timeOfDay: "morning",
                                   location: "location1",
                                   carDescription: "carDescription1",
                                   package: MockDetailPackages.basic)
    
    static let appt2 = Appointment(id: "2",
                                   name: "name2",
                                   phone: "phone2",
                                   date: Date().advanced(by: .day),
                                   timeOfDay: "afternoon",
                                   location: "location2",
                                   carDescription: "carDescription2",
                                   package: MockDetailPackages.deluxe)
}
