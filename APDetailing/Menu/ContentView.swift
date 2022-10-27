//
//  ContentView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    var packages = MockDetailPackages.allPackages
    
    @State var showingRequestAppt = false
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Image("APDetailingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Spacer()
                }
                TabView {
                    ForEach(packages) { package in
                        DetailPackageView(item: package)
                    }
                    .padding(.bottom, 30)
                }
                .tabViewStyle(.page)
                .safeAreaInset(edge: .bottom) {
                    requestButton
                }
            }
        }
    }
    
    var requestButton: some View {
        Button {
            showingRequestAppt.toggle()
        } label: {
            RoundedButtonLabel(title: "Request Appt")
        }
        .padding(.bottom, 20)
        .sheet(isPresented: $showingRequestAppt) {
            RequestDateView()
        }
    }
    
    func requestAppt() {
        showingRequestAppt.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
