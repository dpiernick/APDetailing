//
//  ContactViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import Foundation

@MainActor class ContactViewModel: ObservableObject {
    @Published var showingMessageUI = false
    @Published var showingRequestAppt = false
    
    func call() {
        CallHelper.call(User.shared.adminIDs.first ?? CallHelper.adamWorkPhone)
    }
}
