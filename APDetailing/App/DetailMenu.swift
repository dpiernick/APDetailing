//
//  DetailMenu.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import Foundation

@MainActor class DetailMenu: ObservableObject {
    static let shared = DetailMenu()
    private init() {}
    @Published var menu: DetailMenuObject?
    
    var detailPackages: [DetailPackage]? {
        return menu?.detailPackages
    }
    
    var aLaCarte: [ALaCarteItem]? {
        return menu?.aLaCarte
    }
    
    var basicServices: BasicServices? {
        return menu?.basicServices
    }
}
