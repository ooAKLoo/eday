//
//  Tips.swift
//  eDay
//
//.
//

import SwiftUI
import Foundation
import UserNotifications

var encoder=JSONEncoder()
var decoder=JSONDecoder()


let Notific=UNMutableNotificationContent()


class MedTips:ObservableObject{
    @Published var MedList:[Medication]
    @Published var tol:Int
    @Published var finished:Int
    var count=0
    
    init(){
        self.MedList=[]
        self.tol=1
        self.finished=0
    }
    init(data:[Medication],finished:Int,tolcount:Int){
        self.MedList=[]
        self.finished=finished
        self.tol=tolcount
        for item in data{
            self.MedList.append(Medication(id:self.count,name: item.name, remain: item.remain, time: item.time, dp1:item.dp1,dp2:item.dp2,dp3:item.dp3,dp4:item.dp4, frequ: item.frequ, isChecked: item.isChecked,deleted: item.deleted, timeNum: item.timeNum))
            count+=1
        }
    }
    func finish(id:Int){
        
        //        print("finishInfo1=",self.MedList[id])
        self.MedList[id].isChecked.toggle()
        if(self.MedList[id].isChecked){
            self.finished+=1
        }
        else{
            self.finished-=1
        }
        //        print("finishInfo2=",self.MedList[id])
        self.store()
    }
    
    func add(data:Medication){
//        return
        if data.timeNum<1{
            return
        }
        
        self.MedList.append(Medication(id:self.count,name: data.name,time: data.time,dp1:data.dp1,dp2:data.dp2,dp3:data.dp3,dp4:data.dp4,frequ: data.frequ, isChecked: false, deleted: false, timeNum: data.timeNum))
//        print("add",modiferDateToStr_date_hm(time: self.MedList[count].time[0]))
        //        print("\naddInfo1=",self.MedList[count])
        timesort(index: self.count)
        //        print("addInfo2=",self.MedList[count])
        calculateRemian(index: count)
        //        print("addInfo3=",self.MedList[count])
        //        print(data.time1<data.time2)
        
//        print(modiferDateToStr_date_hm(time: data.time[0]))
//        return
        if data.frequ==0{
            frequ_everyDay(data: self.MedList[count])
        }
        else if data.frequ==1{
            frequ_everyWeek(data: self.MedList[self.count])
        }
        else if data .frequ==2{
            frequ_everyGapDay(data: data)
        }
        self.count+=1
        self.tol+=1
        self.store()
        
    }
    func frequ_everyDay(data:Medication){
        for i in 0..<data.timeNum{
            self.sendNotification_preDay(name: data.name, time: data.time[i], freq: data.frequ)
        }
    }
    func frequ_everyGapDay(data:Medication){
        //        print("每隔一天")
        self.sendNotification_preGapDay(id: data.id)
    }
    func frequ_everyWeek(data:Medication){
//        print("frequ_week",data)
//        print("frequ_week",modiferDateToStr_date_hm(time: data.time[0]))
        self.sendNotification_preWeek(id: data.id)
    }
    func calculateRemian(index:Int){
        if self.MedList[index].timeNum==1{
            self.MedList[index].dp1=1
            self.MedList[index].dp2=0
            self.MedList[index].dp3=0
            self.MedList[index].dp4=0
        }
        else  if self.MedList[index].timeNum==2{
            self.MedList[index].dp1=1
            self.MedList[index].dp2=1
            self.MedList[index].dp3=0
            self.MedList[index].dp4=0
        }
        else  if self.MedList[index].timeNum==3{
            self.MedList[index].dp1=1
            self.MedList[index].dp2=1
            self.MedList[index].dp3=1
            self.MedList[index].dp4=0
        }
        else  if self.MedList[index].timeNum==4{
            self.MedList[index].dp1=1
            self.MedList[index].dp2=1
            self.MedList[index].dp3=1
            self.MedList[index].dp4=1
        }
        self.store()
    }
    
    
    
    func timesort(index:Int){
        var timestrs:[String]=[]
        let timeNum=self.MedList[index].timeNum
        for i in 0..<timeNum{
            timestrs.append(modiferDateToStr(time:self.MedList[index].time[i]))
        }
        
        for i in 1..<self.MedList[index].timeNum{
            if timestrs[i-1]>timestrs[i]{
                var j=i
                while(j>0&&timestrs[j-1]>timestrs[j]){
                    timestrs.swapAt(j-1, j)
                    j-=1
                }
            }
        }
        
        for i in 0..<timeNum{
            self.MedList[index].time[i]=modiferDateToDate(time: timestrs[i])
        }
        
        
    }
    
    func edit(id:Int,data:Medication){
        
//        print(modiferDateToStr_date_hm(time: data.time[0]))
//        return
        self.withdrawNotification(id: id)
        //        print("edit=",data)

        self.MedList[id].name=data.name
        self.MedList[id].frequ=data.frequ
        self.MedList[id].time[0]=data.time[0]
        self.MedList[id].time[1]=data.time[1]
        self.MedList[id].time[2]=data.time[2]
        self.MedList[id].time[3]=data.time[3]
        
        self.MedList[id].isChecked=false
        self.MedList[id].timeNum=data.timeNum
        //        print("edit=1",data)
        timesort(index: id)
        //        print("edit=2",data)
        calculateRemian(index: self.MedList[id].id)
        if data.frequ==0{
            frequ_everyDay(data: self.MedList[id])
        }
        else if data.frequ==1{
            frequ_everyWeek(data: self.MedList[id])
        }
        else if data .frequ==2{
            frequ_everyGapDay(data: data)
        }
        self.store()
        
}
    
    func medDelete(id:Int){
        print("delNotify",self.MedList[id])
        self.withdrawNotification(id: id)
        self.MedList[id].deleted=true
        self.store()
        //        MedList.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }
    
    
    
    func sendNotification_preDay(name:String,time:Date,freq:Int){
//        print("每一天")
        Notific.title=name
//        Notific.subtitle="要按时吃药哦 :)"
        Notific.subtitle="Remember to take your medicine on time :)"
//        Notific.subtitle="Today is Bob's birthday :)"
        Notific.sound=UNNotificationSound.default
        var date = DateComponents()
        date.hour = Int(modiferDateToStr_hh(time: time))
        date.minute = Int(modiferDateToStr_mm(time: time))
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request=UNNotificationRequest(identifier: name + time.description+freq.description, content: Notific, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendNotification_preWeek(id:Int){
//        print("每隔一周")
//        print("send_week",self.MedList[id])
        Notific.title=self.MedList[id].name
        Notific.subtitle="要按时吃药哦 :)"
        Notific.sound=UNNotificationSound.default
        for i in 0..<self.MedList[id].timeNum{
//            print(modiferDateToStr_date_hm(time: self.MedList[id].time[i]))
//            return
            let trigger=UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(7*24*60*60 - timeInterval(date: self.MedList[id].time[i])), repeats: true)//        ''' 此处存在Bug''
            var date = DateComponents()
            date.hour = Int(modiferDateToStr_hh(time: self.MedList[id].time[i]))
            date.minute = Int(modiferDateToStr_mm(time: self.MedList[id].time[i]))
            let request=UNNotificationRequest(identifier: self.MedList[id].name + self.MedList[id].time[i].description+self.MedList[id].frequ.description, content: Notific, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func sendNotification_preGapDay(id:Int){
        print("每隔一天")
        Notific.title=self.MedList[id].name
        Notific.subtitle="要按时吃药哦 :)"
        Notific.sound=UNNotificationSound.default
        for i in 0..<self.MedList[id].timeNum{
            let trigger=UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(24*60*60 - timeInterval(date: self.MedList[id].time[i])), repeats: true)//        ''' 此处存在Bug''
            var date = DateComponents()
            date.hour = Int(modiferDateToStr_hh(time: self.MedList[id].time[i]))
            date.minute = Int(modiferDateToStr_mm(time: self.MedList[id].time[i]))
            let request=UNNotificationRequest(identifier: self.MedList[id].name + self.MedList[id].time[i].description+self.MedList[id].frequ.description, content: Notific, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    
    func withdrawNotification(id:Int){
        for i in 0..<self.MedList[id].timeNum{
            print("撤销通知",i)
            //            撤回已发布的通知
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [self.MedList[id].name+self.MedList[id].time[i].description+self.MedList[id].frequ.description])
            //            撤回未发布的通知
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.MedList[id].name+self.MedList[id].time[i].description+self.MedList[id].frequ.description])
        }
    }
    
    
    func store(){
        let dataStored=try! encoder.encode(self.MedList)
        UserDefaults.standard.set(dataStored, forKey: "MedListX0124")
        //        print("store2=",self.MedList)
    }
}

//
struct Medication: Identifiable, Codable {
    var id: Int
    var name: String
    var remain: Int = 4
    var time: [Date]
    var dp1: Int
    var dp2: Int
    var dp3: Int
    var dp4: Int
    var expire1: Int? = 0
    var expire2: Int? = 0
    var expire3: Int? = 0
    var expire4: Int? = 0
    var frequ: Int
    var isChecked: Bool
    var deleted: Bool
    var timeNum: Int
}

