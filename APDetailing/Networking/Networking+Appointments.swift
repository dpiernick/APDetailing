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
        await fetchAppointments() != nil
    }
    
    static func fetchAppointments() async -> [Appointment]? {
        guard let userID = User.shared.userID else { return nil }
        
        shared.isShowingLoadingIndicator = true
        let result: Result<[Appointment], Error> = await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Appointments").whereField("userID", isEqualTo: userID).order(by: "date").getDocuments() { querySnapshot, error in
                guard error == nil else {
                    continuation.resume(returning: .failure(error!))
                    return
                }
                
                var appts = [Appointment]()
                for doc in querySnapshot?.documents ?? [] {
                    guard var appt = Appointment.decode(dictionary: doc.data()) else {
                        continuation.resume(returning: .failure(NetworkingError.error))
                        return
                    }
                    appt.id = doc.documentID
                    appts.append(appt)
                }
                continuation.resume(returning: .success(appts))
            }
        })
        shared.isShowingLoadingIndicator = false

        if let appointments = try? result.get() {
            await User.shared.setAppointments(appointments)
            return appointments
        } else {
            return nil
        }
    }
    
    static func requestAppointment(appt: Appointment) async -> Bool {
        var appt = appt
        if let userID = User.shared.userID {
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
    
    static func deleteAllAppointments() async -> Bool {
        let appts: [Appointment]? = await fetchAppointments()
        guard let appts = appts else { return false }
        
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
        return deleteResults.allSatisfy({$0})
    }
    
    static func deleteAppointment(apptID: String) async -> Bool {
        await withCheckedContinuation({ continuation in
            Firestore.firestore().collection("Appointments").document(apptID).delete() { error in
                continuation.resume(returning: error == nil)
            }
        })
    }
}
