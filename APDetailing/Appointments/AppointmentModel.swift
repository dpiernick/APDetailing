//
//  AppointmentModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation
import SwiftUI

struct Appointment: Codable, Identifiable, Hashable {
    var id: String?
    var userID: String?
    var name: String?
    var phone: String?
    var date: Date?
    var timeOfDay: String?
    var location: String?
    var carDescription: String?
    var package: DetailPackage?
    var status: AppointmentStatus?
    
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
               \(date?.formatted(date: .complete, time: .omitted) ?? Date().addingTimeInterval(.day).formatted(date: .complete, time: .omitted)) - \(timeOfDay ?? "Any Time")
               \(name ?? "") - \(phone ?? "")
               \(location ?? "")
               \(package?.nameAndPriceString ?? "")
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

extension Appointment {
    static let mockApptRequested = Appointment(id: nil, userID: "3135551212", name: "Dave", phone: "3134028121", date: Date(), timeOfDay: "Morning", location: "Somewhere", carDescription: "A car", package: .inOutDetailPackage, status: .requested)
    static let mockApptCompleted = Appointment(id: nil, userID: "3135551212", name: "Dave", phone: "3134028121", date: Date(), timeOfDay: "Morning", location: "Somewhere", carDescription: "A car", package: .inOutDetailPackage, status: .completed)
}
