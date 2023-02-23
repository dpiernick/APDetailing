//
//  ContentView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import SwiftUI

@MainActor class ContentViewModel: ObservableObject {
    @Published var selectedTab = 0
}

struct ContentView: View {
    @ObservedObject var networking = Networking.shared
    @StateObject var viewModel = ContentViewModel()
    
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
                
                TabView(selection: $viewModel.selectedTab) {
                    ServicesView()
                        .tabItem { Label("Services", systemImage: "car") }
                        .tag(0)
                        .onAppear() { viewModel.selectedTab = 0 }
                    AppointmentsView()
                        .tabItem { Label("Appointments", systemImage: "calendar") }
                        .tag(1)
                        .onAppear() { viewModel.selectedTab = 1 }
                    Text("Contact")
                        .tabItem { Label("Contact", systemImage: "phone") }
                        .tag(2)
                        .onAppear() { viewModel.selectedTab = 2 }
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
