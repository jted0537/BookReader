//
//  ImagePicker.swift
//  SwiftUICamera
//
//  purpose: to show an image picker
//  Created by Mohammad Azam on 2/10/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//
import Foundation
import SwiftUI
import UIKit
import Firebase
import AVKit
import Combine

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var contents: String
    
    init(image: Binding<UIImage?>, showImagePicker: Binding<Bool>, contents: Binding<String>) {
        _image = image
        _showImagePicker = showImagePicker
        _contents = contents
    }
    
    // Using ML for text Recognize Document Text
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showImagePicker = false
            self.image = uiImage
            // ML Part
            let vision = Vision.vision()
            let options = VisionCloudDocumentTextRecognizerOptions()
            options.languageHints = ["ko", "en"]
            let textRecognizer = vision.cloudDocumentTextRecognizer()
            
            let cameraPosition = AVCaptureDevice.Position.back
            let metadata = VisionImageMetadata()
            metadata.orientation = imageOrientation(
                deviceOrientation: UIDevice.current.orientation,
                cameraPosition: cameraPosition
            )
            if let realImage = self.image {
                let visionImage = VisionImage(image: realImage)
                visionImage.metadata = metadata
                textRecognizer.process(visionImage) { result, error in
                    guard error == nil, let result = result else { return }
                    self.contents = result.text
                }
            }
            // ML Part Done
        }
    }
    
    // When user cancel select images
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.showImagePicker = false
    }
    
    // Set Camera Position
    func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        default :
            return .leftTop
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var contents: String
    
    var sourceType: UIImagePickerController.SourceType //= .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, showImagePicker: $showImagePicker, contents: $contents)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}
