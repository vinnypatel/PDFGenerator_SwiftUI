//
//  CreatePDF.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import UIKit

func createPDFWithImages(images: [UIImage]) -> Data? {
    let pdfMetaData = [
        kCGPDFContextCreator: "SwiftUIApp",
        kCGPDFContextAuthor: "YourName",
        kCGPDFContextTitle: "Images PDF"
    ]
    
    let pdfData = NSMutableData()
    
    // A4 page size in points (595 x 842)
    let pageWidth: CGFloat = 595  // A4 width
    let pageHeight: CGFloat = 842 // A4 height
    
    UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, pdfMetaData)
    
    // Define the image placement (2x2 grid)
    let imageWidth: CGFloat = pageWidth / 2
    let imageHeight: CGFloat = pageHeight / 2
    
    // Loop through images and add them to the PDF
    for (index, image) in images.enumerated() {
        // Start a new page every 4 images
        if index % 4 == 0 {
            UIGraphicsBeginPDFPage()
        }
        
        // Calculate row and column position for the grid
        let row = (index % 4) / 2
        let column = (index % 4) % 2
        
        let x = CGFloat(column) * imageWidth
        let y = CGFloat(row) * imageHeight
        
        // Draw the image
        image.draw(in: CGRect(x: x, y: y, width: imageWidth, height: imageHeight))
    }
    
    // End the PDF context
    UIGraphicsEndPDFContext()
    
    return pdfData as Data
}


