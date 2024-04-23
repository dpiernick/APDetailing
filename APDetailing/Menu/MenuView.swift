//
//  MenuView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @ObservedObject var menu = DetailMenu.shared
    @StateObject var viewModel = MenuViewModel()
    @State var selectedTab: Int = 0 {
        didSet {
            
        }
    }
    
    var selectedPackage: DetailPackage { menu.detailPackages?.filter({ $0.id == selectedTab }).first ??  .fullDetailPackage }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(menu.detailPackages ?? []) { package in
                DetailPackageView(package: package, basicServices: menu.basicServices ?? BasicServices())
                    .tag(package.id ?? 0)
            }
            .padding(.bottom, 30)
            
            AddOnsView(addOns: menu.addOns ?? [])
                .tag(99)
                .padding(.bottom, 30)
        }
        .tabViewStyle(.page)
        .safeAreaInset(edge: .bottom) {
            RoundedButton(title: "Request Appointment") {
                viewModel.showingRequestAppt = true
            }
            .padding([.bottom, .leading, .trailing], 20)
            .sheet(isPresented: $viewModel.showingRequestAppt) {
                RequestUpdateApptView(selectedPackage: selectedPackage) { _ in
                    viewModel.showingRequestAppt = false
                }
            }
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
