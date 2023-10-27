//
//  Persistence.swift
//  eDay5
//
//
//

import CoreData

struct PersistenceController{
    static let shard = PersistenceController()
    
    let container:NSPersistentContainer
//    let Docucontainer:NSPersistentContainer
    
    init(){
        container=NSPersistentContainer(name: "Image")
        container.loadPersistentStores{
        (storeDescription,error) in
            if let error = error as NSError?{
                fatalError("未解析错误\(error)")
            }
        }
        
//        Docucontainer=NSPersistentContainer(name: "Docu")
//        Docucontainer.loadPersistentStores{
//        (storeDescription,error) in
//            if let error = error as NSError?{
//                fatalError("未解析错误\(error)")
//            }
//        }
        
    }
}
