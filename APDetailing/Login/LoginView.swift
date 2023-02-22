//
//  LoginView.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/11/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        ZStack {
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            VStack(spacing: 24) {
                if viewModel.phoneSubmitted == false {
                    Text("Log in to book on the app!")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    TextField("Phone", text: $viewModel.phone)
                        .textFieldStyle(.customTextFieldStyle)
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .onChange(of: viewModel.phone) { _ in
                            viewModel.phone = viewModel.phone.formatPhoneNumber()
                        }
                    RoundedButton(title: "Sign In", type: .hugger) {
                        await viewModel.submitPhoneNumber()
                    }
                } else {
                    Text("Enter your one time code")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    TextField("", text: $viewModel.code)
                        .textFieldStyle(.verificationTextFieldStlye)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.code) { newValue in
                            viewModel.code = String(newValue.prefix(6))
                            if viewModel.code.count == 6 {
                                Task { await viewModel.signIn() }
                            }
                        }
                    RoundedButton(title: "Verify", type: .hugger) {
                        await viewModel.signIn()
                    }
                }
            }
            .padding()
            .preferredColorScheme(.dark)
            .alert("Please enter a phone number", isPresented: $viewModel.badPhoneNumber) {}
            .alert("Something went wrong", isPresented: $viewModel.loginError) {}
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
