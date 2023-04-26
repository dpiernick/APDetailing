//
//  Networking+Appointments.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/19/23.
//

import Foundation
import Firebase

extension Networking {
    
    static func fetchAppointments() async -> AppointmentError? {
        shared.isShowingLoadingIndicator = true
        
        let error: AppointmentError?
        if User.shared.isAdmin {
            error = await fetchAllAppointments()
        } else {
            error = await fetchUserAppointments()
        }
        
        shared.isShowingLoadingIndicator = false
        return error
    }
    
    private static func fetchUserAppointments() async -> AppointmentError? {
        guard let userID = User.shared.userID else { return .fetchError }
        guard let snapshot = try? await Firestore.firestore().collection("Appointments").whereField("userID", isEqualTo: userID).order(by: "date").getDocuments() else { return .fetchError }

        var appts = [Appointment]()
        for doc in snapshot.documents {
            if var appt = Appointment.decode(dictionary: doc.data()) {
                //id only exists in field on front end (unless the appt gets updated)
                appt.id = doc.documentID
                appts.append(appt)
            }
        }

        await User.shared.setAppointments(appts)
        return nil
    }
    
    private static func fetchAllAppointments() async -> AppointmentError? {
        guard let snapshot = try? await Firestore.firestore().collection("Appointments").order(by: "date").getDocuments() else { return .fetchError }

        var appts = [Appointment]()
        for doc in snapshot.documents {
            if var appt = Appointment.decode(dictionary: doc.data()) {
                //id only exists in field on front end (unless the appt gets updated)
                appt.id = doc.documentID
                appts.append(appt)
            }
        }

        await User.shared.setAppointments(appts)
        return nil
    }
    
    static func requestAppointment(appt: Appointment) async -> AppointmentError? {
        var appt = appt
        if let userID = User.shared.userID {
            appt.userID = userID
        } else {
            return .submitError
        }

        shared.isShowingLoadingIndicator = true
        let requestSuccess = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Appointments").addDocument(data: appt.jsonDictionary!) { error in
                guard error == nil else {
                    continuation.resume(returning: false)
                    return
                }
                continuation.resume(returning: true)
            }
        })
        shared.isShowingLoadingIndicator = false
        
        if requestSuccess {
            return await fetchAppointments()
        } else {
            return .submitError
        }
    }
    
    static func updateAppointment(appt: Appointment) async -> AppointmentError? {
        shared.isShowingLoadingIndicator = true
        let updateSuccess = await withCheckedContinuation({ continuation in
            guard let id = appt.id, let json = appt.jsonDictionary else {
                continuation.resume(returning: false)
                return
            }

            Firestore.firestore().collection("Appointments").document(id).updateData(json) { error in
                continuation.resume(returning: error == nil)
            }
        })
        shared.isShowingLoadingIndicator = false
        
        if updateSuccess {
            return await fetchAppointments()
        } else {
            return .updateError
        }
    }
    
    static func updateAppointmentStatus(apptID: String, status: AppointmentStatus) async -> AppointmentError? {
        shared.isShowingLoadingIndicator = true
        let updateSuccess = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Appointments").document(apptID).updateData(["status": status.rawValue]) { error in
                continuation.resume(returning: error == nil)
            }
        })
        shared.isShowingLoadingIndicator = false
        
        if updateSuccess {
            return await fetchAppointments()
        } else {
            return .updateError
        }
    }
    
    static func deleteAllAppointments() async -> NetworkingError? {
        guard User.shared.isAdmin == false else { return .error }
        
        guard await fetchAppointments() == nil, let appts = User.shared.appointments else { return .error }
        
        let deleteResults = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for apptID in appts.compactMap({ $0.id }) {
                group.addTask {
                    return await deleteAppointment(apptID: apptID)
                }
            }
            
            var results = [Bool]()
            for await individualResult in group {
                results.append(individualResult)
                print(individualResult)
            }
            print(results)
            return results
        }
        return deleteResults.allSatisfy({$0}) ? nil : .error
    }
    
    static func deleteAppointment(apptID: String) async -> Bool {
        do {
            try await Firestore.firestore().collection("Appointments").document(apptID).delete()
            return true
        } catch {
            return false
        }
    }
}
