//
//  RoundedButton.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/26/22.
//

import SwiftUI

enum ButtonType {
    case primary, secondary, hugger
}

struct RoundedButton: View {
    
    
    var title: String
    @State var color: Color?
    var type: ButtonType
    var action: (() async -> Void)?
    
    init(title: String, color: Color? = nil, type: ButtonType = .primary, action: (() async -> Void)? = nil) {
        self.title = title
        self.color = color
        self.type = type
        self.action = action
    }
    
    var body: some View {
        
        HStack {
            if type == .hugger { Spacer() }
            
            Text(title)
                .frame(maxWidth: type == .hugger ? nil : .infinity, minHeight: 24)
                .preferredColorScheme(.dark)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding()
                .padding(.horizontal, 25)
                .background(type == .secondary ? Color.clear : color ?? Color.red)
                .background {
                    if type == .secondary {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(color ?? .red, lineWidth: 2)
                    }
                }
                .cornerRadius(8)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    Task { await action?() }
            }
            
            if type == .hugger { Spacer() }
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(title: "Button", type: .secondary)
    }
}
