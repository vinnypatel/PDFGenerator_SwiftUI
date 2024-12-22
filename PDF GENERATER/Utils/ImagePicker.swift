//
//  ImagePicker.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//


import SwiftUI
import UIKit

// UIImagePickerControllerWrapper
struct ImagePicker: View {
    @Binding var images: [UIImage]
    @State private var isPicking = false
    
    var body: some View {
        PHPickerViewControllerRepresentable(images: $images)
            .onAppear {
                isPicking = true
            }
    }
}
