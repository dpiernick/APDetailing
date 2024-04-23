//
//  DetailMenu.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import Foundation

@MainActor class DetailMenu: ObservableObject {
    static let shared = DetailMenu()
    @Published var menu: DetailMenuObject = .defaultMenu
    
    private init() {}
    
    func fetchMenu() {
        Task {
            if let menu = await Networking.fetchMenu() {
                self.menu = menu
                LoadingViewHelper.shared.isShowingLaunchScreen = false
            }
        }
    }
    
    var detailPackages: [DetailPackage]? {
        return menu.detailPackages
    }
    
    var addOns: [AddOn]? {
        return menu.addOns
    }
    
    var basicServices: BasicServices? {
        return menu.basicServices
    }
}
