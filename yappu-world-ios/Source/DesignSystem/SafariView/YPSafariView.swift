//
//  YPSafariView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/1/25.
//

import SwiftUI
import SafariServices

import Dependencies

struct YPSafariView: UIViewControllerRepresentable {
    @Environment(\.dismiss)
    private var dismiss
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<YPSafariView>
    ) -> some SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.dismissButtonStyle = .close
        controller.preferredControlTintColor = UIColor(Color.yapp(.semantic(.primary(.normal))))
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(url: url, dismiss: dismiss)
        return coordinator
    }
}

extension YPSafariView {
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        private let url: URL
        private let dismiss: DismissAction
        
        init(url: URL, dismiss: DismissAction) {
            self.url = url
            self.dismiss = dismiss
        }
        
        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            controller.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            dismiss()
            controller.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
