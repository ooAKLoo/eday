//
//  ImageData+CoreDataProperties.swift
//  eDay5
//
//.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var image: Data?
    @NSManaged public var id: Int64

}

//extension ImageData : Identifiable {
//
//}
