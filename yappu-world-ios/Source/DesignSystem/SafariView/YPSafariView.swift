//
//  YPSafariView.swift
//  yappu-world-ios
//
//  Created by 김도형 on 4/1/25.
//

import SwiftUI
import SafariServices

import Dependencies

struct YPSafariView<T>: UIViewControllerRepresentable {
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
        let coordinator = Coordinator(url: url)
        return coordinator
    }
}

extension YPSafariView {
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        @Dependency(Navigation<T>.self)
        private var navigation
        
        private let url: URL
        
        init(url: URL) {
            self.url = url
        }
        
        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
            controller.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            navigation.pop()
            controller.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
