//
//  MessageCoordinator.swift
//  APDetailing
//
//  Created by Dave Piernick on 1/17/23.
//

import Foundation
import UIKit
import SwiftUI
import MessageUI

struct MessageUIView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MessageViewController
    
    @Environment(\.dismiss) var dismiss
    
    @State var body: String?
    var recipient: String?
    var completion: ((_ result: MessageComposeResult) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(controller: self)
    }
    
    func makeUIViewController(context: Context) -> MessageViewController {
        let controller = MessageViewController(recipient: recipient)
        controller.delegate = context.coordinator
        controller.body = self.body
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MessageViewController, context: Context) {
        uiViewController.body = self.body
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, MessageViewDelegate {
        var parent: MessageUIView
        
        init(controller: MessageUIView) {
            self.parent = controller
        }
        
        func messageCompletion(result: MessageComposeResult) {
            self.parent.dismiss()
            self.parent.completion?(result)
        }
    }
}
