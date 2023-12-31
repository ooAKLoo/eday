//
//  TipsConventional.swift
//  eDay2_1
//
//.
//

import Foundation

// The class is designed to manage a list of conventional items.
// It uses the ObservableObject protocol, indicating it can be observed by SwiftUI views for changes.
class ConTips:ObservableObject{
    @Published var ConList:[Conventional]
    @Published var tol:Int
    @Published var Passed:Int
    var count=0
    
    init(){
        self.ConList=[]
        self.tol=1
        self.Passed=0
    }
    init(dp:Int){
        self.ConList=[]
        self.tol=1
        self.Passed=0
        self.ConList.append(Conventional(id: 0, name: "happy birthday", remainDays: 366, initTime: Date.now, time: Date.now, lunarDp: false, isPassed: false, deleted: false))
        self.ConList.append(Conventional(id: 1, name: "happy ", remainDays: 16, initTime: Date.now, time: Date.now, lunarDp: false, isPassed: false, deleted: false))
    }
    init(data:[Conventional],finished:Int,tolcount:Int){
        self.ConList=[]
        self.Passed=finished
        self.tol=tolcount
        for item in data{
//            print("initTime=",gregorian_to_CN(date:item.initTime))
            self.ConList.append(Conventional(id: self.count, name: item.name, remainDays: item.remainDays, initTime: item.initTime, time: item.time, lunarDp: item.lunarDp, isPassed: item.isPassed, deleted: item.deleted))
            self.count+=1
        }
        self.store()
    }

    // Function to add a new conventional item.
    func add(data:Conventional){
        self.tol+=1
        let remainDays = calculateRemainDays(startDate: data.time, nowDate: Date.now)
        let isPassed:Bool=remainDays<=0 ? true : false
        if isPassed==true{
            self.Passed+=1
        }
//        print("add",modiferDateToStr_date_hm(time: data.time),"data=",data)
        ConList.append(Conventional(id: self.count, name: data.name, remainDays: remainDays, initTime: data.initTime, time: data.time, lunarDp: data.lunarDp, isPassed: data.isPassed, deleted: data.deleted))
        self.count+=1
        self.store()
        
    }
    
  
    

    
    // Function to edit an existing conventional item by ID.
    func edit(id:Int,data:Conventional){
//        print("edit",modiferDateToStr_date_hm(time: data.time),"data=",data)
        self.ConList[id].name=data.name
        self.ConList[id].initTime=data.initTime
        self.ConList[id].time=data.time
        self.ConList[id].lunarDp=data.lunarDp
        self.ConList[id].remainDays=calculateRemainDays(startDate: data.time, nowDate: Date.now)
       calculateIspassed()
        self.store()
        
}

    // Calculates the number of items that have passed.
    func calculateIspassed(){
        self.Passed=0
        for item in ConList{
            if item.remainDays<=0{
                self.Passed+=1
            }
        }
    }

    // Marks an item as deleted by ID.
    func conDelete(id:Int){
        self.tol-=1
        self.ConList[id].deleted=true
        self.store()
        //        MedList.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    
    // Saves the list of conventional items (likely to UserDefaults based on the implementation).
    func store(){
        let dataStored=try! encoder.encode(self.ConList)
        UserDefaults.standard.set(dataStored, forKey: "ConList0124X")
        //        print("store2=",self.MedList)
    }
}

// Data structure representing a conventional item.
struct Conventional:Identifiable,Codable{
    
    var id:Int
    var name:String
    var remainDays:Int
    var initTime:Date
    var time:Date
    var lunarDp:Bool
    var isPassed:Bool
    var deleted:Bool
}


//func initConData()->(Int,Int,[Conventional]){


