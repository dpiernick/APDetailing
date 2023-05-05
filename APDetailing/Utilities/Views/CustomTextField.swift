//
//  CustomTextField.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var isLongForm: Bool
    @FocusState private var isEditing
        
    init(_ title: String, text: Binding<String>, isLongForm: Bool = false) {
        self.title = title
        self._text = text
        self.isLongForm = isLongForm
    }
    
    var body: some View {
        ZStack {
            TextField(title, text: $text)
                .padding(.init(top: 8, leading: 8, bottom: isLongForm ? 30 : 8, trailing: 8))
                .frame(minHeight: 24)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.red, lineWidth: 1)
                }
                .onTapGesture {
                    isEditing = true
                }
                .focused($isEditing)
        }
    }
}

struct CustomVerifyTextField: View {
    var title: String
    @Binding var text: String
        
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text)
            .font(.system(size: 40))
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
            .multilineTextAlignment(.center)
            .frame(width: 200)
            .textContentType(.oneTimeCode)
            .keyboardType(.numberPad)
    }
}
