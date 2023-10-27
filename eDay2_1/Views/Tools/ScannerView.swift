//
//  ScannerView.swift
//  Sacn
//
//.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHander)
    }
    
    
   final class Coordinator: NSObject,VNDocumentCameraViewControllerDelegate{
        private let completionHandler:([String]?)->Void
        
         init(completion: @escaping ([String]?)->Void) {
            self.completionHandler=completion
        }
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
           let recognizer=TextRecognizer(cameraScan: scan)
           recognizer.recognizeText(withCompletionHandler: completionHandler)
       }
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
           completionHandler(nil)
       }
       func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
           completionHandler(nil)
       }
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController=VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    private let completionHander:([String]?)->Void
    
    init(completion: @escaping ([String]?)->Void) {
        self.completionHander=completion
    }
}


