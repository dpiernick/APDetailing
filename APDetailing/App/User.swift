//
//  User.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation

@MainActor class User: ObservableObject {
    var phoneNumber: String? = nil
    @Published var isLoggedIn: Bool = true
    @Published var appointments: [Appointment]? = nil
    
    static let shared = User()

    private init() {}
    
    func setIsLoggedIn(_ loggedIn: Bool, phoneNumber: String? = nil) async {
        self.isLoggedIn = loggedIn
        self.phoneNumber = phoneNumber
    }
    
    func setAppointments(_ appts: [Appointment]) async {
        self.appointments = appts
    }
}
