//
//  PDFCreator.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import SwiftUI
import UIKit

//class PDFCreator {
//    static func createPDF(images: [UIImage], outputURL: URL) {
//        // Define the page size (A4 size - 595 x 842 points)
//        let pageWidth: CGFloat = 595
//        let pageHeight: CGFloat = 842
//        
//        // Set the desired padding between images
//        let horizontalPadding: CGFloat = 20
//        let verticalPadding: CGFloat = 20
//        let imageWidth: CGFloat = (pageWidth - (3 * horizontalPadding)) / 2  // 2 images per row, with padding
//        let imageHeight: CGFloat = (pageHeight - (3 * verticalPadding)) / 2  // 2 images per column, with padding
//        
//        // Create a PDF renderer with the A4 page size
//        let format = UIGraphicsPDFRendererFormat()
//        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
//        
//        // Render to the output file URL
//        try? renderer.writePDF(to: outputURL, withActions: { context in
//            var imageIndex = 0
//            
//            // Add pages with 4 images each (2 rows, 2 columns)
//            while imageIndex < images.count {
//                context.beginPage()
//                
//                // Draw images in a grid (2 rows x 2 columns)
//                for row in 0..<2 {
//                    for col in 0..<2 {
//                        if imageIndex < images.count {
//                            let image = images[imageIndex]
//                            
//                            // Calculate position and size for the image
//                            let xPosition = CGFloat(col) * (imageWidth + horizontalPadding) + horizontalPadding
//                            let yPosition = CGFloat(row) * (imageHeight + verticalPadding) + verticalPadding
//                            let imageRect = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
//                            
//                            // Draw the image
//                            image.draw(in: imageRect)
//                            imageIndex += 1
//                        }
//                    }
//                }
//            }
//        })
//    }
//}


class PDFCreator {
    static func createPDF(images: [UIImage], outputURL: URL) async throws {
        let pageWidth: CGFloat = 595
        let pageHeight: CGFloat = 842
        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = 20
        let imageWidth: CGFloat = (pageWidth - (3 * horizontalPadding)) / 2
        let imageHeight: CGFloat = (pageHeight - (3 * verticalPadding)) / 2
        
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        // Perform PDF creation asynchronously
        try await Task.detached {
            try renderer.writePDF(to: outputURL, withActions: { context in
                var imageIndex = 0
                while imageIndex < images.count {
                    context.beginPage()
                    for row in 0..<2 {
                        for col in 0..<2 {
                            if imageIndex < images.count {
                                let image = images[imageIndex]
                                let xPosition = CGFloat(col) * (imageWidth + horizontalPadding) + horizontalPadding
                                let yPosition = CGFloat(row) * (imageHeight + verticalPadding) + verticalPadding
                                let imageRect = CGRect(x: xPosition, y: yPosition, width: imageWidth, height: imageHeight)
                                image.draw(in: imageRect)
                                imageIndex += 1
                            }
                        }
                    }
                }
            })
        }.value
    }
}
