//
//  ServicesViewModel.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/22/23.
//

import Foundation
import SwiftUI

@MainActor class MenuViewModel: ObservableObject {
    @ObservedObject var user = User.shared
    @Published var showingRequestAppt = false
    @Published var showingMessageUI = false
}
