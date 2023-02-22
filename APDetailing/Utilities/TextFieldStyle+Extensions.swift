//
//  TextFieldStyle+Extensions.swift
//  APDetailing
//
//  Created by Dave Piernick on 11/2/22.
//

import Foundation
import SwiftUI

extension TextFieldStyle where Self == CustomTextFieldStyle {
    static var customTextFieldStyle: CustomTextFieldStyle {
        return CustomTextFieldStyle()
    }
}

extension TextFieldStyle where Self == CustomLongFormTextFieldStyle {
    static var customLongFormTextFieldStyle: CustomLongFormTextFieldStyle {
        return CustomLongFormTextFieldStyle()
    }
}

extension TextFieldStyle where Self == CustomLongFormTextFieldStyle {
    static var verificationTextFieldStlye: VerificationTextFieldStyle {
        return VerificationTextFieldStyle()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .frame(minHeight: 24)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
    }
}

struct CustomLongFormTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.init(top: 8, leading: 8, bottom: 30, trailing: 8))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
    }
}

struct VerificationTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 40))
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
            .multilineTextAlignment(.center)
            .frame(width: 200)
            .textContentType(.oneTimeCode)
    }
}
