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
        
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        TextField(title, text: $text)
            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
            .frame(minHeight: 24)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.red, lineWidth: 1)
            }
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField()
//    }
//}
