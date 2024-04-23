//
//  ContentViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 4/26/23.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor class ContentViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var showingUserScreen = false
    @Published var deepLinkAppt: Appointment?
    
    func handleDeepLink() async {
        switch DeepLinkRouter.shared.deepLinkView {
        case let .appointment(id):
            await fetchAppointment(id)
            selectedTab = 1
        default: return
        }
    }
    
    func fetchAppointment(_ id: String) async {
        LoadingViewHelper.shared.isShowingLoadingIndicator = true
        guard let apptData = try? await Firestore.firestore().collection("Appointments").document(id).getDocument().data() else { return }
        var appt = Appointment.decode(dictionary: apptData)
        appt?.id = id
        deepLinkAppt = appt
        LoadingViewHelper.shared.isShowingLoadingIndicator = false
    }
}
