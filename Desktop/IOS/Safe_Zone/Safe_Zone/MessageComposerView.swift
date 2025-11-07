//
//  MessageComposerView.swift
//  Safe_Zone
//
//  Created by Tun Tauk Oo on 17/10/2568 BE.
//

import SwiftUI
import MessageUI

struct MessageComposerView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator
        controller.recipients = recipients
        controller.body = body
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposerView

        init(parent: MessageComposerView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
            parent.isPresented = false
        }
    }
}

