//
//  TextRecognize.swift
//  Sacn
//
//.
//

import Foundation
import Vision
import VisionKit

final class TextRecognizer{
    let camernScan:VNDocumentCameraScan
    init(cameraScan:VNDocumentCameraScan){
        self.camernScan=cameraScan
    }
    private let queue = DispatchQueue(label: "scan-codes",qos: .default,attributes: [],autoreleaseFrequency: .workItem)
    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])->Void){
        queue.async {
            let images=(0..<self.camernScan.pageCount).compactMap({
                self.camernScan.imageOfPage(at:$0).cgImage
            })
            let imagesAndRequests=images.map({(image:$0,request:VNRecognizeTextRequest())})
            let textPerPage=imagesAndRequests.map{image,request->String in
                let handler=VNImageRequestHandler(cgImage: image, options: [:])
                do{
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else{return""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator:"\n")
                }
                    catch{
                        print(error)
                        return ""
                    }
                }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
