//
//  Networking+Appointments.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/19/23.
//

import Foundation
import Firebase

extension Networking {
    
    static func fetchAppointments() async -> Bool {
        guard let userID = User.shared.phoneNumber else { return false }
        
        shared.isShowingLoadingIndicator = true
        let result: Result<[Appointment], Error> = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Appointments").whereField("userID", isEqualTo: userID).getDocuments() { querySnapshot, error in
                guard error == nil else {
                    continuation.resume(returning: .failure(error!))
                    return
                }
                
                var appts = [Appointment]()
                for doc in querySnapshot?.documents ?? [] {
                    guard var appt = Appointment.decode(dictionary: doc.data()) else { return }
                    appt.id = doc.documentID
                    appts.append(appt)
                }
                continuation.resume(returning: .success(appts))
            }
        })
        shared.isShowingLoadingIndicator = false

        if let appointments = try? result.get() {
            await User.shared.setAppointments(appointments)
            return true
        } else {
            return false
        }
    }
    
    static func requestAppointment(appt: Appointment) async -> Bool {
        var appt = appt
        if let userID = User.shared.phoneNumber {
            appt.userID = userID
        } else {
            return false
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
            return false
        }
    }
    
    static func updateAppointment(appt: Appointment) async -> Bool {
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
            return false
        }
    }
    
    static func updateAppointmentStatus(apptID: String, status: AppointmentStatus) async -> Bool {
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
            return false
        }
    }
}
