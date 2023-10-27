//
//  Tips.swift
//  eDay
//
//.
//

import SwiftUI
import Foundation

//var encoder=JSONEncoder()
//var decoder=JSONDecoder()


class Eassy:ObservableObject{
    @Published var EassyList:[SingleEassy]
    var count=0
    
    init(){
        self.EassyList=[]
        load()
    }
    init(data:[SingleEassy]){
        self.EassyList=[]
        for item in data{
            self.EassyList.append(SingleEassy(id: self.count, title: item.title, text: item.text, date: item.date,isDeleted:item.isDeleted))
            count+=1
        }
    }
    func add(data:SingleEassy){
        print("添加....1",data)
        self.EassyList.append(SingleEassy(id:self.count,title: data.title,
                                          text: data.text, date: data.date,isDeleted:false))
        self.count+=1
        print("添加....2",EassyList)
        self.store()
    }
    func edit(index:Int,data:SingleEassy){
        self.EassyList[index].title=data.title
        self.EassyList[index].text=data.text
        self.store()
    }
    
    func delete(index:Int){
        print("delete了")
        self.EassyList[index].isDeleted=true
        self.store()
    }
    
    func store(){
        let dataStored=try! encoder.encode(self.EassyList)
        UserDefaults.standard.set(dataStored, forKey: "EassyList")
//        print("store2=",self.MedList)
    }
    func load(){
        var del:[SingleEassy]=[]
        if let dataStored =  UserDefaults.standard.object(forKey: "EassyList") as? Data{
            let data=try! decoder.decode([SingleEassy].self, from: dataStored)
            for item in data{
                if !item.isDeleted{
                    self.EassyList.append(SingleEassy(id: EassyList.count, title: item.title, text: item.text, date: item.date, isDeleted: item.isDeleted))
                    self.count+=1
                }
                else{
                    del.append(SingleEassy(id: EassyList.count, title: item.title, text: item.text, date: item.date, isDeleted: item.isDeleted))
                }
            }
        }
        print("加载完成...",self.EassyList)
        print("加载完成del的...",del)
    }

}

//
struct SingleEassy:Identifiable,Codable{
    var id:Int
    var title:String
    var text:String
    var date:Date
    var isDeleted:Bool
}
