//
//  AppointmentViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 1/17/23.
//

import Foundation
import Firebase
import MessageUI
import MapKit
import SwiftUI

enum AppointmentError: Error {
    case invalidAppointment
    case submitError
    case loggedOut
}

@MainActor class RequestUpdateApptViewModel: NSObject, ObservableObject {
    var id: String = ""
    @Published var name: String = ""
    @Published var phone: String = User.shared.userID?.formatPhoneNumber() ?? ""
    @Published var package: DetailPackage = .fullDetailPackage
    @Published var date: Date = Date() + .day
    @Published var timeOfDay: TimeOfDay?
    @Published var location: String = ""
    @Published var carDescription: String = ""
    var status: AppointmentStatus = .requested
    
    var menu: DetailMenuObject? = nil
    
    @Published var invalidAppointment = false
    @Published var isShowingLogin = false
    @Published var isShowingError = false
    @Published var isShowingMessageUI = false
    
    var isEditing = false
    
    var fetcher = MKLocalSearchCompleter()
    var shouldFetch = true
    @Published var suggestions = [String]()
    @Published var isShowingLocationError = false
    @Published var distanceTooFar = false
    
    var completion: ((Result<Appointment, AppointmentError>) -> Void)?
    
    var appt: Appointment {
        Appointment(id: id,
                    userID: User.shared.userID,
                    name: name,
                    phone: phone,
                    date: date,
                    timeOfDay: timeOfDay?.rawValue,
                    location: location,
                    carDescription: carDescription,
                    package: package,
                    status: status)
    }
    
    init(appt: Appointment? = nil, selectedPackage: DetailPackage = .fullDetailPackage, menu: DetailMenuObject? = nil, isEditing: Bool = false, completion: ((Result<Appointment, AppointmentError>) -> Void)? = nil) {
        super.init()
        if let appt = appt {
            self.id = appt.id ?? ""
            self.name = appt.name ?? ""
            self.phone = appt.phone ?? ""
            self.package = appt.package ?? selectedPackage
            self.date = appt.date ?? Date() + .day
            self.timeOfDay = TimeOfDay(rawValue: appt.timeOfDay ?? "")
            self.location = appt.location ?? ""
            self.carDescription = appt.carDescription ?? ""
            self.status = appt.status ?? .requested
        } else {
            self.package = selectedPackage
        }
        self.menu = menu
        self.isEditing = isEditing
        self.completion = completion
    }
    
    func handleLogin(result: LoginResult) async {
        switch result {
        case .success:
            await requestAppointment()
        case .dismiss: isShowingLogin = false
        }
    }
    
    func requestAppointment() async {
        guard appt.validateAppt() else {
            invalidAppointment = true
            return
        }
        
        guard User.shared.isLoggedIn else {
            isShowingLogin = true
            return
        }
        
        guard await isLocationInRange() else { return }
        
        let success = await Networking.requestAppointment(appt: appt)
        isShowingError = !success
        completion?(success ? .success(appt) : .failure(.submitError))
    }
    
    func updateAppointment() async {
        guard await isLocationInRange() else { return }

        let success = await Networking.updateAppointment(appt: appt)
        isShowingError = !success
        completion?(success ? .success(appt) : .failure(.submitError))
    }
    
    func getLocationSuggestions(query: String) {
        guard shouldFetch else {
            shouldFetch = true
            return
        }
        
        guard query.count > 2 else {
            suggestions = []
            return
        }
        
        fetcher.delegate = self
        fetcher.resultTypes = .address
        //Set bounding Region to USA
        fetcher.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.995, longitude: -95.856),
                                            span: MKCoordinateSpan(latitudeDelta: 24.863, longitudeDelta: 57.813))
        self.fetcher.queryFragment = query
    }
    
    func selectSuggestion(_ suggestion: String) {
        shouldFetch = false
        location = suggestion
        suggestions = []
    }
    
    func isLocationInRange() async -> Bool {
        guard let addressLocation = (try? await CLGeocoder().geocodeAddressString(appt.location ?? ""))?.first?.location else {
            isShowingLocationError = true
            return false
        }
        
        let westland = CLLocation(latitude: 42.324, longitude: -83.4)
        let distance = westland.distance(from: addressLocation)/1609.34 //convert to miles
        if distance > 50 {
            distanceTooFar = true
            return false
        } else {
            return true
        }
    }
}

extension RequestUpdateApptViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = Array(completer.results.map({ "\($0.title), \($0.subtitle)"}).prefix(5))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
