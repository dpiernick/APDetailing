//
//  SwiftUIView.swift
//  APDetailing
//
//  Created by Dave Piernick on 10/27/22.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView {
            Text("Hi")
        }
    }
}
