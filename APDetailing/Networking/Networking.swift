//
//  Networking.swift
//  APDetailing
//
//  Created by Dave Piernick on 1/30/23.
//

import Foundation
import Firebase

@MainActor class Networking: NSObject, ObservableObject {
    static var shared = Networking()
    @Published var isShowingLoadingIndicator = false
}

enum NetworkingError: Error {
    case error
}
