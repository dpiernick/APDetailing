//
//  Date+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/26/23.
//

import Foundation

extension Date {
    
    func dateString() -> String {
        self.formatted(date: .long, time: .omitted)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    static func fromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        return dateFormatter.date(from: dateString)
    }
}

extension Date {
    var monthAbbv: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    
    var dayOfMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
}

extension Date {
    func timeOfDay() -> TimeOfDay? {
        guard let hour = self.hourOfDay(), let minute = self.nearestQuarterHour(), let amPm = self.amPm() else { return nil }
        return TimeOfDay(hour: hour, minute: minute, amPm: amPm)
    }
    
    func hourOfDay(twentyFourHourClock: Bool = false) -> Int? {
        guard let hour = Calendar.current.dateComponents([.hour], from: self).hour else { return nil }
        if twentyFourHourClock {
            return hour
        } else if hour == 0 {
            return 12
        } else {
            return hour > 12 ? hour - 12 : hour
        }
    }
    
    func nearestQuarterHour() -> QuarterHour? {
        guard let minute = Calendar.current.dateComponents([.minute], from: self).minute else { return nil }
        switch minute {
        case 8...22: return .fifteen
        case 23...37: return .thirty
        case 38...52: return .fortyFive
        default: return .onTheHour
        }
    }
    
    func amPm() -> AmPm? {
        guard let hour = Calendar.current.dateComponents([.hour], from: self).hour else { return nil }
        return hour > 12 ? .pm : .am
    }
}

extension Date {
    func setTime(timeOfDay: TimeOfDay) -> Date {
        let hours: Int
        if timeOfDay.amPm == .am {
            hours = timeOfDay.hour == 12 ? 0 : timeOfDay.hour
        } else {
            hours = timeOfDay.hour == 12 ? 12 : timeOfDay.hour + 12
        }
        return Calendar.current.startOfDay(for: self).addingTimeInterval(.hour * Double(hours)).addingTimeInterval(.minute * Double(timeOfDay.minute.rawValue))
    }
    
    static func tomorrowAt9AM() -> Date {
        Calendar.current.startOfDay(for: Date() + .day).addingTimeInterval(.hour * 9)
    }
    
    static func tomorrowDateString() -> String {
        Date().addingTimeInterval(.day).dateString()
    }
}
