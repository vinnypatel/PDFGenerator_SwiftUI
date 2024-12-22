//
//  ContentView.swift
//  PDF GENERATER
//
//  Created by Vinay Patel on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isExporting = false
    @State private var outputPDFURL: URL? = nil
    @State private var showShareSheet = false
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false
    @State private var isFileShared = false
    @State private var editMode: EditMode = .inactive // Add state for editMode
    @State private var isCreatingPDF = false
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
        VStack {
            // Buttons at the top
            Button("Select Images") {
                showImagePicker.toggle()
            }
            .padding()
            
            //            if isCreatingPDF {
            //                            ProgressView("Creating PDF...")
            //                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            //                                .padding()
            //                        }
            // Scrollable content
            VStack {
                if !selectedImages.isEmpty {
                    Text("Selected Images:")
                        .font(.headline)
                        .padding(.top)
                    ScrollView {
                        // Display images in a grid
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack {
                                    let imageSize = (UIScreen.main.bounds.width - 60) / 2  // Make width and height the same (square)
                                    
                                    // Image view
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageSize, height: imageSize)  // Set both width and height the same
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    // Delete button
                                    Button(action: {
                                        // Delete the image
                                        selectedImages.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Circle().fill(Color.white).shadow(radius: 4))
                                    }
                                    .padding(4) // Padding from the bottom-right corner
                                    .position(x: imageSize - 20, y: imageSize - 20) // Position at the bottom-right corner
                                }
                                .padding(4)
                            }
                            .onMove { indices, newOffset in
                                selectedImages.move(fromOffsets: indices, toOffset: newOffset)
                            }
                        }
                        .environment(\.editMode, $editMode) // Bind the grid to the editMode state
                    }
                    
                    //                    if let outputPDFURL = outputPDFURL {
                    //                        Text("PDF Created: \(outputPDFURL.absoluteString)")
                    //                            .padding()
                    //                    }
                }
            }
            
            Button("Create PDF") {
                isExporting.toggle()
                Task {
                    await createPDF()
                }
            }
            .padding()
            .disabled(selectedImages.isEmpty)
            
            // Share sheet
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $selectedImages)
            }
            .sheet(isPresented: $showShareSheet) {
                if let outputPDFURL = outputPDFURL {
                    ShareSheet(activityItems: [outputPDFURL], onDismiss: {
                        if self.isFileShared {
                            // Remove the local file after sharing
                            self.deleteLocalFile(at: outputPDFURL)
                        }
                    }, onShareCompletion: {
                        self.isFileShared = true  // Set the flag to true after sharing is completed
                    })
                }
            }
        }
            if isCreatingPDF {
                            VStack {
                                Spacer()
                                ProgressView("Creating PDF...")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .padding()
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5)) // Translucent black background
                            .cornerRadius(10)
                            .edgesIgnoringSafeArea(.all)
                        }
    }
        .padding()
        .environment(\.editMode, $editMode) // Set edit mode at the root level to enable reordering
    }
    
    // Function to delete the file
    func deleteLocalFile(at url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("File deleted successfully.")
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }
    
    // Async PDF creation function
    func createPDF() async {
        isCreatingPDF = true  // Show the progress view
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // Create timestamped filename
            let timestamp = DateFormatter().formattedCurrentTimestamp()
            let outputFileName = "\(timestamp)_output.pdf"
            let outputURL = documentsURL.appendingPathComponent(outputFileName)
            
            // Generate the PDF asynchronously
            try await PDFCreator.createPDF(images: selectedImages, outputURL: outputURL)
            // Update output URL once the PDF is created
            self.outputPDFURL = outputURL
            self.showShareSheet.toggle()
        } catch {
            print("Error creating PDF: \(error.localizedDescription)")
        }
        isCreatingPDF = false
    }
}
#Preview {
    ContentView()
}
