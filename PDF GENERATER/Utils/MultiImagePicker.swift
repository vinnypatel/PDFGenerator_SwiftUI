//
//  MultiImagePicker.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//
import SwiftUI
import PhotosUI

struct MultiImagePicker: UIViewControllerRepresentable {
    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImages: [UIImage]
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultiImagePicker

        init(parent: MultiImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var selectedImages: [UIImage] = []
            
            // Load the selected images asynchronously
            let dispatchGroup = DispatchGroup()

            for result in results {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    dispatchGroup.leave()
                }
            }

            // Wait until all images are loaded
            dispatchGroup.notify(queue: .main) {
                self.parent.selectedImages = selectedImages
                self.parent.isImagePickerPresented = false
            }
        }

        func pickerDidCancel(_ picker: PHPickerViewController) {
            parent.isImagePickerPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0  // Allow unlimited selections
        config.filter = .images   // Filter to only images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
