//
//  CustomLongFormTextField.swift
//  APDetailing
//
//  Created by Dave Piernick on 2/28/23.
//

import SwiftUI

struct CustomLongFormTextField: View {
    var title: String
    @Binding var text: String
    
    @FocusState private var isEditing
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text, axis: .vertical)
            .padding(.init(top: 8, leading: 8, bottom: 30, trailing: 8))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
            .onTapGesture {
                isEditing = true
            }
            .focused($isEditing)
    }
}
