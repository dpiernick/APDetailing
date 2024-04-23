//
//  ContentView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var user = User.shared
    @ObservedObject var loadingHelper = LoadingViewHelper.shared
    @ObservedObject var menu = DetailMenu.shared
    @ObservedObject var deepLinkRouter = DeepLinkRouter.shared
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            if loadingHelper.isShowingLaunchScreen {
                Image("APDetailingLogo")
                    .resizable()
                    .scaledToFit()
            } else {
                VStack {
                    ZStack {
                        Image("APDetailingLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, alignment: .center)
                        
                        if user.isLoggedIn {
                            Button {
                                viewModel.showingUserScreen = true
                            } label: {
                                Label {
                                    Text("")
                                } icon: {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .tint(.white)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 24)
                        }
                    }
                    
                    TabView(selection: $viewModel.selectedTab) {
                        MenuView()
                            .tabItem { Label("Services", systemImage: "car") }
                            .tag(0)
                            .onAppear() { viewModel.selectedTab = 0 }
                        AppointmentsView()
                            .tabItem { Label("Appointments", systemImage: "calendar") }
                            .tag(1)
                            .onAppear() { viewModel.selectedTab = 1 }
                        ContactView()
                            .tabItem { Label("Contact", systemImage: "phone") }
                            .tag(2)
                            .onAppear() { viewModel.selectedTab = 2 }
                    }
                    .onReceive(deepLinkRouter.$deepLinkView) { _ in
                        Task { await viewModel.handleDeepLink() }
                    }
                }
                .overlay(content: {
                    if loadingHelper.isShowingLoadingIndicator {
                        ZStack {
                            Color.black.opacity(0.9)
                            ProgressView()
                                .scaleEffect(x: 3, y: 3)
                        }
                    }
                })
                .overlay {
                    if viewModel.showingUserScreen {
                        ZStack {
                            Color.black.opacity(0.9)
                                .onTapGesture {
                                    viewModel.showingUserScreen = false
                                }
                            LogoutDeleteAcctView() {
                                viewModel.showingUserScreen = false
                            }
                        }
                    }
                }
            }
            
            if let appt = viewModel.deepLinkAppt {
                AppointmentCellDetailView(appt: appt) {
                    viewModel.deepLinkAppt = nil
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
