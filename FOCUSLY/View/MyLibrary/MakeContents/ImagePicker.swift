//
//  ImagePicker.swift
//  SwiftUICamera
//
//  Created by Mohammad Azam on 2/10/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//
import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var imageLoadState: Bool
    
    init(image: Binding<UIImage?>, showImagePicker: Binding<Bool>, imageLoadState: Binding<Bool>) {
        _image = image
        _showImagePicker = showImagePicker
        _imageLoadState = imageLoadState
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiImage
            showImagePicker = false
            imageLoadState.toggle()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImagePicker = false
        imageLoadState.toggle()
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var imageLoadState: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, showImagePicker: $showImagePicker, imageLoadState: $imageLoadState)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}
