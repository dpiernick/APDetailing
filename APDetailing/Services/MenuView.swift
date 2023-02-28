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
    @State var selectedPackage: DetailPackage = .inOutDetailPackage
    
    var body: some View {
        TabView(selection: $selectedPackage) {
            ForEach(menu.detailPackages ?? []) { package in
                DetailPackageView(package: package, basicServices: menu.basicServices ?? BasicServices())
                    .tag(package)
            }
            .padding(.bottom, 30)
        }
        .tabViewStyle(.page)
        .safeAreaInset(edge: .bottom) {
            RoundedButton(title: "Request Appointment") {
                viewModel.showingRequestAppt = true
            }
            .padding([.bottom, .leading, .trailing], 20)
            .sheet(isPresented: $viewModel.showingRequestAppt) {
                RequestUpdateApptView(selectedPackage: selectedPackage, menu: DetailMenu.shared.menu) { _ in
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
