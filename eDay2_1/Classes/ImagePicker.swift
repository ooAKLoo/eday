//
//  ImagePicker.swift
//  eDay6
//
//  Created by 杨东举 on 2022/1/11.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable{
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    @Binding var selectedImage:UIImage
    @Binding var selectedImageData:Data
    @Binding var selectedImageList:[Data]
    @Environment(\.presentationMode) private var presentionMode
    var sourceType:UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context:UIViewControllerRepresentableContext<ImagePicker>) ->
        UIImagePickerController{
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            imagePicker.delegate = context.coordinator
            
            return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    final class Coordinator:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        var parent:ImagePicker
        
        init(_ parent:ImagePicker){
            self.parent = parent
        }
        
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
