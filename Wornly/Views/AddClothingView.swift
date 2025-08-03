//
//  AddClothingSheet.swift
//  Wornly
//
//  Created by Tyler Berlin on 7/30/25.
//

import Foundation
import SwiftUI
import PhotosUI
import SwiftData
import UIKit
import AVFoundation

struct AddClothingView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var isPresented: Bool

    @State var selectedImage: PhotosPickerItem?
    @State var imageData: Data?
    @State var name: String = ""
    @State var brand: String = ""
    @State var category: String = ""
    @State private var showPhotoSourceDialog = false
    @State private var showCamera = false
    @State private var showNameAlert = false
    @State private var cameraErrorMessage: String? = nil
    @State private var showCameraErrorAlert: Bool = false
    @State private var showPhotosPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Photo")) {
                    Button {
                        showPhotoSourceDialog = true
                    } label: {
                        if let data = imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 200)
                                    .cornerRadius(8)
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .confirmationDialog("Photo Source", isPresented: $showPhotoSourceDialog) {
                        Button("Choose Photo") {
                            showPhotosPicker = true
                        }
                        Button("Take Photo") {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                AVCaptureDevice.requestAccess(for: .video) { granted in
                                    DispatchQueue.main.async {
                                        if granted {
                                            showCamera = true
                                        } else {
                                            cameraErrorMessage = "Camera access is required to take photos. Please allow camera access in Settings."
                                            showCameraErrorAlert = true
                                        }
                                    }
                                }
                            } else {
                                cameraErrorMessage = "Camera is not available on this device."
                                showCameraErrorAlert = true
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .photosPicker(isPresented: $showPhotosPicker, selection: $selectedImage, matching: .images)
                    .onChange(of: selectedImage) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                await MainActor.run { self.imageData = data }
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showCamera) {
                        ImagePicker(image: $imageData)
                    }
                }

                Section(header: Text("Details")) {
                    HStack {
                        Text("Name")
                        Text("*").foregroundColor(.red)
                        TextField("Required", text: $name)
                            .autocapitalization(.words)
                            .submitLabel(.next)
                    }
                    TextField("Brand", text: $brand)
                    TextField("Category", text: $category)
                }
            }
            .navigationTitle("Add Clothing")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if name.trimmingCharacters(in: .whitespaces).isEmpty {
                            showNameAlert = true
                            return
                        }
                        let newItem = ClothingItem(name: name, category: category.isEmpty ? "Uncategorized" : category, brand: brand, imageData: imageData, dateAdded: Date())
                        modelContext.insert(newItem)
                        try? modelContext.save()
                        isPresented = false
                    }
                    .alert("Name is required", isPresented: $showNameAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Please enter a name for your clothing item.")
                    }
                }
            }
            .alert(cameraErrorMessage ?? "", isPresented: $showCameraErrorAlert) {
                Button("OK", role: .cancel) { cameraErrorMessage = nil }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Data?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let vc = UIViewController()
            return vc as! UIImagePickerController
        }
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage,
               let data = uiImage.jpegData(compressionQuality: 0.8) {
                parent.image = data
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddClothingView(isPresented: .constant(true))
}
