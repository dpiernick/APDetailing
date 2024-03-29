//
//  TimeInterval+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import Foundation

extension TimeInterval {
    static var minute: Double = 60
    static var hour: Double = minute * 60
    static var day: Double = hour * 24
    static var week: Double = day * 7
    static var year: Double = day * 365
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
    static func fromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM dd, yyyy"
        return dateFormatter.date(from: dateString)
    }
    
    func dateString() -> String {
        self.formatted(date: .long, time: .omitted)
    }
    
    static func tomorrowString() -> String {
        Date().addingTimeInterval(.day).formatted(date: .long, time: .omitted)
    }
}
