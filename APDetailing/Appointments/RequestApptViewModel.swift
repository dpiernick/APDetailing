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

enum AppointmentError: Error {
    case invalidAppointment
    case submitError
    case loggedOut
}
extension RequestUpdateApptView {
    class LocationSuggestionHandler: NSObject, MKLocalSearchCompleterDelegate {
        nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            completer.results.forEach({ print($0) })
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            print(error)
        }
    }
}

extension RequestUpdateApptView {
//    class SearchHandler: NSObject, MKLocalSearchCompleterDelegate {}
    @MainActor class ViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
        var id: String = ""
        @Published var name: String = ""
        @Published var phone: String = ""
        @Published var package: DetailPackage = MockDetailPackages.basic
        @Published var date: Date = Date() + .day
        @Published var timeOfDay: TimeOfDay?
        @Published var location: String = ""
        @Published var carDescription: String = ""
        
        @Published var invalidAppointment = false
        @Published var isShowingError = false
        @Published var isShowingMessageUI = false
        @Published var isShowingLogin = false
        
        var isEditing = false
        var fetchingLocationTask = Task {}
        var suggestions: [String]?
        var completion: ((Result<Appointment, AppointmentError>) -> Void)
        
        var appt: Appointment {
            Appointment(id: id,
                        name: name,
                        phone: phone,
                        date: date,
                        timeOfDay: timeOfDay?.rawValue,
                        location: location,
                        carDescription: carDescription,
                        package: package,
                        status: .requested)
        }

        init(appt: Appointment?, completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
            if let appt = appt {
                self.id = appt.id ?? ""
                self.name = appt.name ?? ""
                self.phone = appt.phone ?? ""
                self.package = appt.package ?? MockDetailPackages.basic
                self.date = appt.date ?? Date()
                self.timeOfDay = TimeOfDay(rawValue: appt.timeOfDay ?? "")
                self.location = appt.location ?? ""
                self.carDescription = appt.carDescription ?? ""
            }
            self.completion = completion
        }
        
        init(selectedPackage: DetailPackage, completion: @escaping ((Result<Appointment, AppointmentError>) -> Void)) {
            self.package = selectedPackage
            self.completion = completion
        }
        
        func requestAppointment() async {
            guard appt.validateAppt() else {
                invalidAppointment = true
                return
            }
            
            guard User.shared.isLoggedIn && User.shared.phoneNumber != nil else {
                isShowingLogin = true
                return
            }
            
            let success = await Networking.requestAppointment(appt: appt)
            isShowingError = !success
            completion(success ? .success(appt) : .failure(.submitError))
        }
        
        func updateAppointment() async {
            let success = await Networking.requestAppointment(appt: appt)
            isShowingError = !success
            completion(success ? .success(appt) : .failure(.submitError))
        }
        
        func getLocationSuggestions(query: String) async -> [String] {
            guard query.count > 3 else { return }
            
            let searchCompleter = MKLocalSearchCompleter()
            searchCompleter.delegate = self
            DispatchQueue.main.async {
                searchCompleter.queryFragment = query
                if searchCompleter.isSearching { print("searching") }
            }
            
            
            
//            fetchingLocationTask.cancel()
//            fetchingLocationTask = Task {
//                var searchRequest = MKLocalSearch.Request()
//                searchRequest.naturalLanguageQuery = query
//                searchRequest.resultTypes = .address
//                let search = MKLocalSearch(request: searchRequest)
//                let response = (try? await search.start())?.mapItems.description ?? "no items"
//                print(response)
//                suggestions = [response]
//            }
        }
        
        nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            completer.results.forEach({ print($0) })
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            print(error)
        }
    }
}
