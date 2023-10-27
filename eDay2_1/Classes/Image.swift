//
//  Image.swift
//  eDay6
//
//.
//

import SwiftUI
import Foundation


var Imageencoder=JSONEncoder()
var Imagedecoder=JSONDecoder()

//class ImageData:ObservableObject{
//    @Published var ImageList:[SingleImage]
//    var count=0
//
//    init(){
//        self.ImageList=[]
//    }
//
//    init(data:[SingleImage]){
//        self.ImageList=[]
//
//        for item in data{
//            self.ImageList.append(SingleImage(id: self.count, image: item.image))
//            count+=1
//        }
//    }
//
//    func store(){
//        let dataStored=try! Imageencoder.encode(self.ImageList)
//        UserDefaults.standard.set(dataStored, forKey: "ImageListX33")
////        print("store2=",self.MedList)
//    }
//}


enum LayoutType:CaseIterable{
    case single
    case double
    case adaptive
    
    var columns:[GridItem]{
        switch self{
        case .single:
            return [GridItem(.flexible(),spacing: 0)]
        case .double:
            return [
                GridItem(.flexible(),spacing: 1),
                GridItem(.flexible(),spacing: 1)
            ]
        case .adaptive:
            return [GridItem(.adaptive(minimum: 100),spacing: 1)]
        }
    }
    
      
}



//struct SingleImage:Identifiable,Encodable,Decodable{
//    var id:Int
//    var image:Binary
//}
