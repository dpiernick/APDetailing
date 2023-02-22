//
//  ContentView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var networking = Networking.shared
    @State var selectedTab = 0
    
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
                
                TabView(selection: $selectedTab) {
                    ServicesView()
                        .tabItem { Label("Services", systemImage: "car") }
                        .tag(0)
                        .onAppear() { self.selectedTab = 0 }
                    AppointmentsView()
                        .tabItem { Label("Appointments", systemImage: "calendar") }
                        .tag(1)
                        .onAppear() { self.selectedTab = 1 }
                }
            }
        }
        .overlay(content: {
            if networking.isShowingLoadingIndicator {
                ZStack {
                    Color.black.opacity(0.9)
                    ProgressView()
                        .scaleEffect(x: 3, y: 3)
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
