//
//  DetailMenu.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import Foundation

@MainActor class DetailMenu: ObservableObject {
    static let shared = DetailMenu()
    @Published var menu: DetailMenuObject?
    @Published var showingLaunchScreen = false
    
    private init() {
        Task { await Networking.fetchMenu() }
    }
    
    var detailPackages: [DetailPackage]? {
        return menu?.detailPackages
    }
    
    var addOns: [AddOn]? {
        return menu?.addOns
    }
    
    var basicServices: BasicServices? {
        return menu?.basicServices
    }
}
