//
//  ShareSheet.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import UIKit
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var onDismiss: () -> Void
    var onShareCompletion: () -> Void  // Add a closure to notify the completion of the share action
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Listen for dismissal and invoke onDismiss
        activityController.completionWithItemsHandler = { _, _, _, _ in
            // Mark the file as shared
            self.onShareCompletion()  // Trigger the completion handler
            self.onDismiss()          // Dismiss after sharing is complete
        }
        
        return activityController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
