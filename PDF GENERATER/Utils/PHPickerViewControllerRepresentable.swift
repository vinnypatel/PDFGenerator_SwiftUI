//
//  PHPickerViewControllerRepresentable.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import SwiftUI
import UIKit
import PhotosUI

struct PHPickerViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(images: $images)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0  // 0 means no limit, allow multi-selection
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var images: [UIImage]
        
        init(images: Binding<[UIImage]>) {
            _images = images
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            images.removeAll()
            
            // For each selected result, attempt to load the image
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.images.append(image)
                        }
                    }
                }
            }
            
            picker.dismiss(animated: true)
        }
    }
}
