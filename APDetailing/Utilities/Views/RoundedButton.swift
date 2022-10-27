//
//  RoundedButton.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/26/22.
//

import SwiftUI

struct RoundedButtonLabel: View {
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .font(.title3)
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(16)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonLabel(title: "Button")
    }
}
