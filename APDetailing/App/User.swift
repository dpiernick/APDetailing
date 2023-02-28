//
//  User.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation

@MainActor class User: ObservableObject {
    @Published var userID: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var appointments: [Appointment]? = nil
    var adminIDs = [String]()
    
    static let shared = User()

    private init() {}
    
    var isAdmin: Bool {
        return userID != nil ? adminIDs.contains(userID!) : false
    }
    
    func setIsLoggedIn(_ loggedIn: Bool, phoneNumber: String) async {
        self.isLoggedIn = loggedIn
        self.userID = phoneNumber
    }
    
    func setAppointments(_ appts: [Appointment]) async {
        self.appointments = appts
    }
    
    func logOut() {
        userID = nil
        appointments = nil
        isLoggedIn = false
    }
}

struct AdminIDs: Codable {
    var ids: [String]?
}
