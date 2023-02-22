//
//  MenuView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import Foundation
import SwiftUI

struct ServicesView: View {
    var packages = MockDetailPackages.allPackages
    @ObservedObject var user = User.shared
    @State var selectedPackage: DetailPackage = MockDetailPackages.basic
    @State var showingRequestAppt = false
    @State var showingMessageUI = false
    
    var body: some View {
        TabView(selection: $selectedPackage) {
            ForEach(packages) { package in
                DetailPackageView(item: package)
                    .tag(package)
            }
            .padding(.bottom, 30)
        }
        .tabViewStyle(.page)
        .onChange(of: selectedPackage) { _ in }
        .safeAreaInset(edge: .bottom) {
            RequestAppointmentButton()
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView()
    }
}
