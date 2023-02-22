//
//  MessageViewController.swift
//  APDetailing
//
//  Created by Dave Piernick on 1/17/23.
//

import UIKit
import MessageUI

protocol MessageViewDelegate {
    func messageCompletion(result: MessageComposeResult)
}

class MessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var delegate: MessageViewDelegate?
    var recipient: String?
    var body: String?
    
    init(delegate: MessageViewDelegate? = nil, recipient: String?, body: String? = nil) {
        self.delegate = delegate
        self.recipient = recipient
        self.body = body
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMessageInterface()
    }
    
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.recipients = [self.recipient ?? ""]
        composeVC.body = self.body ?? ""
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: false)
        } else {
            self.delegate?.messageCompletion(result: MessageComposeResult.failed)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: false)
        self.delegate?.messageCompletion(result: result)
    }
}
