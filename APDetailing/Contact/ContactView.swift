//
//  ContactView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import SwiftUI

struct ContactView: View {
    @Environment(\.openURL) private var openURL
    @StateObject var viewModel: ContactViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ContactViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Contact AP Detailing")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack {
                Image("instagramLogo")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .padding(.trailing)
                Text("@ap_mobile_detailing")
                    .font(.system(size: 20, weight: .bold))
            }
            .onTapGesture {
                openURL(WebHelper.instagramDeepLink) { success in
                    if !success { openURL(WebHelper.instagramWebLink )}
                }
            }
            
            HStack {
                Image("facebookLogo")
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 75, height: 75)
                    .padding(.trailing)
                Text("A.P. Detailing")
                    .font(.system(size: 20, weight: .bold))
            }
            .onTapGesture {
                openURL(WebHelper.facebookWebLink)
            }
            
            Spacer()
            
            Text("By Phone:  \(CallHelper.primaryPhone)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)
            HStack(spacing: 20) {
                RoundedButton(title: "Call", type: .secondary) { viewModel.call() }
                RoundedButton(title: "Text", type: .secondary) { viewModel.showingMessageUI = true }
                    .sheet(isPresented: $viewModel.showingMessageUI) {
                        MessageUIView(recipient: CallHelper.primaryPhone)
                    }
            }
            .padding(.bottom)
            

            
            Spacer()
        }
        .padding()
        .safeAreaInset(edge: .bottom) {
            RoundedButton(title: "Request Appointment") {
                viewModel.showingRequestAppt = true
            }
            .padding([.bottom, .leading, .trailing], 20)
            .sheet(isPresented: $viewModel.showingRequestAppt) {
                RequestUpdateApptView() {_ in }
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
