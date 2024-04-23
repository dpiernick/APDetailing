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
    var dateString: String?
    var timeString: String?
    var timeOfDay: String?
    var location: String?
    var carDescription: String?
    var package: DetailPackage?
    var addOns: [AddOn]?
    var status: AppointmentStatus?
    
    var addOnsPrice: Int? { return addOns?.compactMap({ $0.price ?? 0 }).reduce(0, +) }
    
    var totalApptPrice: Int? {
        let packagePrice = package?.price ?? 0
        let suvPrice = package?.isSUV == true ? 40 : 0
        let addOnsPrice = addOnsPrice ?? 0
        return packagePrice + suvPrice + addOnsPrice
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
                location.isNotNilAndNotEmpty &&
                package != nil &&
                carDescription.isNotNilAndNotEmpty)
    }
    
    func requestMessageBody() -> String {
        guard validateAppt() else { return "" }
        return """
               Hi, I'd like to request an appointment:
               \(dateString ?? Date.tomorrowDateString()) - \(timeString ?? "Any Time")
               \(name ?? "") - \(phone ?? "")
               \(location ?? "")
               \(package?.nameAndPriceString ?? "")
               \((addOns ?? [AddOn]()).compactMap({ $0.name }).joined())
               \(carDescription ?? "No car description")
               """
    }
}

enum AppointmentStatus: String, Codable {
    case requested = "Requested"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

extension Appointment {
    static let mockApptRequested = Appointment(id: nil, userID: "3135551212", name: "Dave", phone: "3134028121", date: Date(), timeString: "11:30 AM", location: "Somewhere", carDescription: "A car", package: .fullDetailPackage, addOns: [AddOn(name: "Add On 1", price: 50), AddOn(name: "Add On 2", price: 50)], status: .requested)
    static let mockApptCompleted = Appointment(id: nil, userID: "3135551212", name: "Dave", phone: "3134028121", date: Date(), timeString: "11:30 AM", location: "Somewhere", carDescription: "A car", package: .fullDetailPackage, addOns: [AddOn(name: "Add On", price: 50)], status: .completed)
}
