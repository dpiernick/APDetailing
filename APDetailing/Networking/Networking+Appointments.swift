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
        guard let data = appt.jsonDictionary else {
            return .submitError }
        
        var appt = appt
        if let userID = User.shared.userID {
            appt.userID = userID
        } else {
            return .submitError
        }

        shared.isShowingLoadingIndicator = true
        guard let _ = try? await Firestore.firestore().collection("Appointments").document(appt.id ?? UUID().uuidString).setData(data) else {
            return .submitError
        }
        
        guard (await fetchAppointments()) == nil else {
            return .fetchError
        }
        shared.isShowingLoadingIndicator = false

        return nil
    }
    
    static func updateAppointment(appt: Appointment) async -> AppointmentError? {
        guard let json = appt.jsonDictionary else { return .updateError }
        
        shared.isShowingLoadingIndicator = true
        guard let _ = try? await Firestore.firestore().collection("Appointments").document(appt.id ?? UUID().uuidString).updateData(json) else { return .submitError }
        guard (await fetchAppointments()) == nil else { return .fetchError }
        shared.isShowingLoadingIndicator = false
        
        return nil
    }
    
    static func updateAppointmentStatus(apptID: String, status: AppointmentStatus) async -> AppointmentError? {
        shared.isShowingLoadingIndicator = true
        guard let _ = try? await Firestore.firestore().collection("Appointments").document(apptID).updateData(["status": status.rawValue]) else { return .submitError }
        guard (await fetchAppointments()) == nil else { return .fetchError }
        shared.isShowingLoadingIndicator = false
        
        return nil
    }
    
    static func deleteAllAppointments() async -> NetworkingError? {
        guard let userID = User.shared.userID, User.shared.isAdmin == false else { return .adminDelete }
        guard let query = try? await Firestore.firestore().collection("Appointments").whereField("userID", isEqualTo: userID).getDocuments() else { return nil }
        
        var apptIDs = [String]()
        for doc in query.documents {
            apptIDs.append(doc.documentID)
        }
        
        let deleteResults = await withTaskGroup(of: Bool.self, returning: [Bool].self) { group in
            for apptID in apptIDs {
                group.addTask {
                    return await deleteAppointment(apptID: apptID)
                }
            }
            
            var results = [Bool]()
            for await individualResult in group {
                results.append(individualResult)
            }
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
