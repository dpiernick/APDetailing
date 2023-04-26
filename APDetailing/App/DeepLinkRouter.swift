//
//  DeepLinkRouter.swift
//  APDetailing
//
//  Created by Dave Piernick on 4/25/23.
//

import Foundation

enum DeepLinkDestination {
    case appointment(id: String)
}

class DeepLinkRouter: ObservableObject {
    static let shared = DeepLinkRouter()
    @Published var deepLinkView: DeepLinkDestination?
}
