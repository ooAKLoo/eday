//
//  ImagePicker.swift
//  eDay6
//
//.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper around the UIKit's UIImagePickerController to allow image selection within a SwiftUI view.
struct ImagePicker: UIViewControllerRepresentable{
    /// Creates a coordinator object that communicates changes between the `ImagePicker` and the `UIImagePickerController`.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    @Binding var selectedImage:UIImage
    @Binding var selectedImageData:Data
    @Binding var selectedImageList:[Data]
    @Environment(\.presentationMode) private var presentionMode
    var sourceType:UIImagePickerController.SourceType = .photoLibrary
    
    /// Creates and returns an image picker view controller.
    func makeUIViewController(context:UIViewControllerRepresentableContext<ImagePicker>) ->
        UIImagePickerController{
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
            
            return imagePicker
    }
    
    /// Updates the view controller's state to match the SwiftUI view's properties.
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    /// A coordinator to manage the communication and data flow between the `ImagePicker` and the `UIImagePickerController`.
    final class Coordinator:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var parent:ImagePicker
        
        init(_ parent:ImagePicker){
            self.parent = parent
        }
        
        /// Handles the selection of an image from the picker.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                parent.selectedImage = image
                
                
                let images = info[.originalImage] as! UIImage
                
//                let dataImg = images.jpegData(compressionQuality: 0.50)//This convert the image in Data
                print("二进制：",images.jpegData(compressionQuality: 0.50)!)
                parent.selectedImageData = images.jpegData(compressionQuality: 0.50)! //This convert the image in Data
                parent.selectedImageList.append( images.jpegData(compressionQuality: 0.50)!)
               
            }
            parent.presentionMode.wrappedValue.dismiss()//This implementation dismiss the ImagePickerView after choose any image
        }
    }
}
