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
